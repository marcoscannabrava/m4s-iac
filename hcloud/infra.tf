# Create SSH Key
resource "tls_private_key" "global_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_sensitive_file" "ssh_private_key_openssh" {
  filename        = "${path.module}/${var.prefix}_id_rsa"
  content         = tls_private_key.global_key.private_key_openssh
  file_permission = "0600"
}

resource "local_file" "ssh_public_key_openssh" {
  filename = "${path.module}/${var.prefix}_id_rsa.pub"
  content  = tls_private_key.global_key.public_key_openssh
}

# Create Hetzner Cloud Resources: Network, Subnet, VPS
resource "hcloud_network" "private" {
  name     = "${var.prefix}-private-network"
  ip_range = var.network_cidr
}

resource "hcloud_network_subnet" "private" {
  type         = "cloud"
  network_id   = hcloud_network.private.id
  network_zone = var.network_zone
  ip_range     = var.network_ip_range
}

resource "hcloud_ssh_key" "server_ssh_key" {
  name       = "${var.prefix}-instance-ssh-key"
  public_key = tls_private_key.global_key.public_key_openssh
}

# Single HCloud VPS Instance
resource "hcloud_server" "server" {
  name        = "${var.prefix}-server"
  image       = var.hcloud_image
  server_type = var.hcloud_server
  location    = var.hcloud_location
  ssh_keys    = [hcloud_ssh_key.server_ssh_key.id]

  network {
    network_id = hcloud_network.private.id
  }

  depends_on = [
    hcloud_network_subnet.private
  ]
}

# Cloudflare DNS Records
resource "cloudflare_record" "root" {
  zone_id         = var.cloudflare_zone_id
  name            = var.domain
  value           = hcloud_server.server.ipv4_address
  type            = "A"
  ttl             = 1
  proxied         = true
  allow_overwrite = true
  comment         = ""
  tags            = []
}

resource "cloudflare_record" "www" {
  zone_id         = var.cloudflare_zone_id
  name            = "www.${var.domain}"
  value           = hcloud_server.server.ipv4_address
  type            = "A"
  ttl             = 1
  proxied         = true
  allow_overwrite = true
  comment         = ""
  tags            = []
}

# Setup SSH Config — required for Ansible Step
resource "null_resource" "ssh_setup" {

  triggers = {
    prefix  = var.prefix
    host_ip = hcloud_server.server.ipv4_address
    ssh_key = tls_private_key.global_key.private_key_openssh
  }

  # Remove Host from known_hosts and Add Credentials to SSH Config
  provisioner "local-exec" {
    command = <<EOF
ssh-keygen -f ~/.ssh/known_hosts -R ${hcloud_server.server.ipv4_address} &&
cat <<EOT >> ~/.ssh/config

Host ${var.prefix}
  HostName ${hcloud_server.server.ipv4_address}
  User root
  IdentityFile ${abspath(path.module)}/${var.prefix}_id_rsa
  IdentitiesOnly yes
EOT
EOF
  }
}

# Ansible Integration
resource "null_resource" "ansible_configuration" {

  triggers = {
    always_run = "${timestamp()}"
  }

  # Prepare Ansible Inventory
  provisioner "local-exec" {
    working_dir = "../server"
    command     = <<EOF
sed -e 's/host_ip/${hcloud_server.server.ipv4_address}/' \
-e 's/host_user/${local.node_username}/' \
inventory.template > inventory
EOF
  }

  # Install Ansible Galaxy Roles and run Ansible Playbook
  provisioner "local-exec" {
    working_dir = "../server"
    command     = <<EOF
ansible-galaxy install -r requirements.yml &&
ansible-playbook -i inventory -u root --private-key ../hcloud/${var.prefix}_id_rsa main.yml
EOF
  }

}
