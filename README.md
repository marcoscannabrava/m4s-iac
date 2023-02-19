# IaC repo for a Simple Rancher-managed K3s Installation on Hetzner Cloud

```sh
# Quickstart
# 1. Rename terraform.tfvars.example to terraform.tfvars and edit the variables
# 2. Run commands below
cd rancher/hcloud
terraform init
terraform plan # check if resources are what you'd expect
terraform apply

# 3. Log in to the `rancher_server_url` shown at the end with the `admin` user and the password you defined in `rancher_server_admin_password`
```