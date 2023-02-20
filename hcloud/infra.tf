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

# HCloud Instance for creating a single node RKE cluster and installing the portainer server
resource "hcloud_server" "portainer_server" {
  name        = "${var.prefix}-portainer-server"
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

# portainer resources
module "portainer_common" {
  source = "../portainer"

  node_public_ip             = hcloud_server.portainer_server.ipv4_address
  node_internal_ip           = one(hcloud_server.portainer_server.network[*]).ip
  node_username              = local.node_username
  ssh_private_key_pem        = tls_private_key.global_key.private_key_pem
  portainer_kubernetes_version = var.portainer_kubernetes_version

  cert_manager_version    = var.cert_manager_version
  portainer_version         = var.portainer_version
  portainer_helm_repository = var.portainer_helm_repository

  portainer_server_dns = join(".", ["portainer", hcloud_server.portainer_server.ipv4_address, "sslip.io"])
  admin_password     = var.portainer_server_admin_password

  # workload_kubernetes_version = var.workload_kubernetes_version
  # workload_cluster_name       = "quickstart-hcloud-custom"
}


# TODO: for starters, we're tunning everything in the same node as portainer_server
# HCloud instance for creating a single node workload cluster
# resource "hcloud_server" "quickstart_node" {
#   name        = "${var.prefix}-worker"
#   image       = "ubuntu-22.04"
#   server_type = var.instance_type
#   location    = var.hcloud_location
#   ssh_keys    = [hcloud_ssh_key.quickstart_ssh_key.id]

#   network {
#     network_id = hcloud_network.private.id
#   }

#   user_data = templatefile(
#     "${path.module}/files/userdata_quickstart_node.template",
#     {
#       username         = local.node_username
#       register_command = module.portainer_common.custom_cluster_command
#     }
#   )

#   provisioner "remote-exec" {
#     inline = [
#       "echo 'Waiting for cloud-init to complete...'",
#       "cloud-init status --wait > /dev/null",
#       "echo 'Completed cloud-init!'",
#     ]

#     connection {
#       type        = "ssh"
#       host        = self.ipv4_address
#       user        = local.node_username
#       private_key = tls_private_key.global_key.private_key_pem
#     }
#   }

#   depends_on = [
#     hcloud_network_subnet.private
#   ]
# }