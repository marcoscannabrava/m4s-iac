# IaC repo for m4s server on Hetzner

This server runs on a single Hetzner Cloud instance and hosts a blog, [m4s.dev](https://m4s.dev/), and a few other apps.

# Quickstart

1. [Install Requirements](#requirements-installation)
   1. Terraform
   2. Ansible
2. Set up Environment Variables: `hcloud/terraform.tfvars.example` --> `hcloud/terraform.tfvars`
3. Run: `terraform init && terraform apply`


## Requirements Installation
```sh
# Install Terraform (via apt — for Debian-based distros)
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update
sudo apt install terraform

# Install Ansible (via pip)
python3 -m pip install ansible
```

## Provision commands separating Terraform and Ansible
```sh
M4S_DIR=`pwd` # (optional) sets variable to this directory for readability purposes

# Terraform Infra Provisioning
cd $M4S_DIR/hcloud
terraform init
terraform plan # check if resources are what you'd expect
terraform apply

# Ansible Configuration Management
terraform apply -target=null_resource.ansible-configuration  # applies Terraform to a single resource
# OR set up inventory from inventory.template and run:
cd $M4S_DIR/server
ansible-galaxy install -r requirements.yml
ansible-playbook --private-key="$M4S_DIR/hcloud/ed_25519" -i inventory main.yml
```


## Setting up CICD
Current configuration creates a private SSH key (`hcloud/ed_25519`) that can be used to configure CICD.

