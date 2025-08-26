# Arch Linux Setup on VMware Workstation with Ansible

## Prerequisites
- Installed Arch Linux
- Encrypted partitions with cryptsetup
- One user in the wheel group with a password

## Install Ansible
Follow this steps: https://wiki.archlinux.org/title/Ansible

- For Pacman installation: ansible-galaxy collection install community.general

## Setup Instructions
1. Clone this repository:
   ```bash
   git clone <your-repo-url>
   cd dotfiles/ansible
   ansible-playbook -i inventory playbook.yml
   ```

