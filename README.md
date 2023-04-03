# IaC repo for m4s server on Hetzner

# Quickstart

1. Install Requirements
   1. Terraform
   2. Ansible
2. Set up Environment Variables
   1. `hcloud/terraform.tfvars.example` --> `hcloud/terraform.tfvars`
   2. `server/inventory.example` --> `server/inventory`
3. Run commands below

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

# TODO
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
