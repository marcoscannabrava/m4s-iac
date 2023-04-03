# IaC repo for m4s server on Hetzner

# Quickstart

1. [Install Requirements](#requirements-installation)
   1. Terraform
   2. Ansible
2. Set up Environment Variables
   1. `hcloud/terraform.tfvars.example` --> `hcloud/terraform.tfvars`
   2. `server/inventory.example` --> `server/inventory`
3. [Run Terraform to provision infra and Ansible to configure server](#provision-commands)


## Requirements Installation
```sh
# Terraform
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update
sudo apt install terraform

# Ansible
python3 -m pip install ansible
```

## Provision commands
```sh
M4S_DIR=`pwd`

# Terraform Infra Provisioning
cd $M4S_DIR/hcloud
terraform init
terraform plan # check if resources are what you'd expect
terraform apply

# Ansible Configuration Management
cd $M4S_DIR/server
ansible-galaxy install -r requirements.yml
ansible-playbook -i inventory main.yml
```

___
___

# TODO

# WIP:
setting up SSH keys for Ansible
[Connection methods and details &mdash; Ansible Documentation](https://docs.ansible.com/ansible/latest/inventory_guide/connection_details.html#:~:text=Ansible%20precedence%20rules.-,Setting%20up%20SSH%20keys,%2D%2Dask%2Dbecome%2Dpass%20.)

## Ansible configuration: 
- install `nginx`, `docker`, `docker-compose`
- start nginx
- set up cicd:
  - add github credentials to hetzner
  - goal: it should be possible for a github action to ssh and run these deploy commands (script?)
    - `cd to /apps, clone git repo if not exists`
    - `cd into it, pull from git repo`
    - `run docker-compose up -d --build`
    - + adds nginx.conf file and restarts nginx service



# Reference
[Terraform Registry - Github SSH Key](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/user_ssh_key)
