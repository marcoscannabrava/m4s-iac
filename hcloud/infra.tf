# HCloud infrastructure resources

resource "tls_private_key" "global_key" {
  algorithm = "ED25519"
}

resource "local_sensitive_file" "ssh_private_key_pem" {
  filename        = "${path.module}/ed_25519"
  content         = tls_private_key.global_key.private_key_pem
  file_permission = "0600"
}

resource "local_file" "ssh_public_key_openssh" {
  filename = "${path.module}/ed_25519.pub"
  content  = tls_private_key.global_key.public_key_openssh
}

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
resource "hcloud_ssh_key" "quickstart_ssh_key" {
  name       = "${var.prefix}-instance-ssh-key"
  public_key = tls_private_key.global_key.public_key_openssh
}

# Single HCloud VPS Instance
resource "hcloud_server" "m4s_server" {
  name        = "${var.prefix}-m4s-server"
  image       = "ubuntu-22.04"
  server_type = var.instance_type
  location    = var.hcloud_location
  ssh_keys    = [hcloud_ssh_key.quickstart_ssh_key.id]

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
      private_key = tls_private_key.global_key.private_key_pem
    }
  }

  depends_on = [
    hcloud_network_subnet.private
  ]
}
