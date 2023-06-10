# IaC repo for m4s server on Hetzner

This is the IaC (Infrastructure as Code) repo for my personal server that runs on a single Hetzner Cloud instance and hosts a blog, [m4s.dev](https://m4s.dev/), and a few other apps.

It spins up one Hetzner Cloud box running Ubuntu, installs Docker, configures its firewall, DNS records on Cloudflare, and sets up the local SSH configuration to connect to the new host.

# Quickstart

1. [Install Requirements](#requirements-installation)
   1. Terraform
   2. Ansible
2. Infrastructure Requirements
   1. Hetzner Account, and API Token
   2. Cloudflare Account, Zone, and API Token
3. Set up Environment Variables: `hcloud/terraform.tfvars.example` --> `hcloud/terraform.tfvars`
4. Run: `cd hcloud && terraform init && terraform apply`

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

___

## Breakdown of provision commands: Terraform and Ansible
```sh
make apply # simple quickstart --> runs terraform and ansible

# OR
M4S_DIR=`pwd` # (optional) sets variable to this directory for readability purposes

# Terraform Infra Provisioning
cd $M4S_DIR/hcloud
terraform init
terraform plan
terraform apply

# Ansible Configuration Management
terraform apply -target=null_resource.ansible-configuration  # applies Terraform to a single resource
# OR set up inventory from inventory.template and run:
cd $M4S_DIR/server
ansible-galaxy install -r requirements.yml
ansible-playbook --private-key="$M4S_DIR/hcloud/id_rsa" -i inventory main.yml
```

# Note

📝 There is a known bug with the Cloudflare Terraform Provider. To work around it, it might be necessary to comment out or uncomment the `tags` property in the DNS resources as needed to apply/destroy the configuration.


# Deployment

Build app in server, create an NGINX file with one of the following configurations and run `nginx -s reload`.

```nginx
# to serve multiplw web servers
server {
    listen 80;
    server_name app1.m4s.dev;

    location / {
        proxy_pass http://localhost:8000;
    }
}

server {
    listen 80;
    server_name app2.m4s.dev;

    location / {
        proxy_pass http://localhost:8001;
    }
}

# to serve static files
server {
    listen 80;
    server_name blog.m4s.dev;

    location / {
        root /path/to/folder;
        try_files $uri $uri.html $uri/ /fallback/index.html;
    }
}
```