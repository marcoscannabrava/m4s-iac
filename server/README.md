# Installs Docker and configures Firewall

## Quick Start Guide

### 1 - Install dependencies

  1. Install [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).
  2. Install role dependencies: `ansible-galaxy install -r requirements.yml`

### 2 - Configure the inventory

Copy the `inventory.template` to `inventory`, and change `host_ip` and `host_user`

### 3 - Run the playbook

`ansible-playbook -i inventory main.yml`


## Credits

This module was forked from [Jeff Geerling](https://www.jeffgeerling.com/)'s [Ansible for DevOps](https://www.ansiblefordevops.com/) work.

[GitHub - geerlingguy/ansible-for-devops: Ansible for DevOps examples.](https://github.com/geerlingguy/ansible-for-devops)
