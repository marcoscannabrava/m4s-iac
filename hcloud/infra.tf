# HCloud infrastructure resources

# Create SSH Key --- BEGIN
resource "tls_private_key" "global_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_sensitive_file" "ssh_private_key_openssh" {
  filename        = "${path.module}/${var.prefix}.pk"
  content         = tls_private_key.global_key.private_key_openssh
  file_permission = "0600"
}

resource "local_file" "ssh_public_key_openssh" {
  filename = "${path.module}/${var.prefix}.pub"
  content  = tls_private_key.global_key.public_key_openssh
}
# Create SSH Key --- END

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

# Temporary key pair used for SSH accesss
resource "hcloud_ssh_key" "server_ssh_key" {
  name       = "${var.prefix}-instance-ssh-key"
  public_key = tls_private_key.global_key.public_key_openssh
}

# Single HCloud VPS Instance
resource "hcloud_server" "m4s_server" {
  name        = "${var.prefix}-server"
  image       = var.hcloud_image
  server_type = var.hcloud_server
  location    = var.hcloud_location
  ssh_keys    = [hcloud_ssh_key.server_ssh_key.id]

  network {
    network_id = hcloud_network.private.id
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = self.ipv4_address
      user        = local.node_username
      private_key = tls_private_key.global_key.private_key_openssh
    }
  }

  depends_on = [
    hcloud_network_subnet.private
  ]
}

# Ansible Integration
resource "null_resource" "ansible_configuration" {
  
  triggers = {
    always_run = "${timestamp()}"
  }

  # Prepare Ansible Inventory
  provisioner "local-exec" {
    working_dir = "../server"
    command = <<EOF
sed -e 's/host_prefix/${var.prefix}/' \
-e 's/host_ip/${hcloud_server.m4s_server.ipv4_address}/' \
-e 's/host_user/${local.node_username}/' \
-e 's/host_admin_email/${var.admin_email}/' \
inventory.template > inventory
EOF
  }

  # Install Ansible Galaxy Roles and run Ansible Playbook
  provisioner "local-exec" {
    working_dir = "../server"
    command = <<EOF
ansible-galaxy install -r requirements.yml &&
ansible-playbook -i inventory -u root --private-key ../hcloud/${var.prefix}.pk main.yml
EOF
  }

}