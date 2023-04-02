# # ------ WIP ------

# # CICD with GitHub Actions

# resource "github_user_ssh_key" "m4s_server_key" {
#   title = "${var.prefix}-server-key"
#   key   = tls_private_key.global_key.public_key_openssh
# }