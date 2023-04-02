# IaC repo for m4s server on Hetzner

# Quickstart
```sh
cd hcloud
terraform init
terraform plan # check if resources are what you'd expect
terraform apply
```

# TODO
- infra-configuration: 
  - install `nginx`, `docker`, `docker-compose`
- set up cicd:
  - add github credentials to hetzner
  - goal: it should be possible for a github action to ssh and run these deploy commands
    - `cd to /apps, clone git repo if not exists`
    - `cd into it, pull from git repo`
    - `run docker-compose up -d --build`

# Reference
[Terraform Registry - Github SSH Key](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/user_ssh_key)