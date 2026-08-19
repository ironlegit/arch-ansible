# Arch Linux Infrastructure Setup with Ansible

This repository automates post-installation configuration for Arch Linux in a VMware environment.

## What This Does

- Updates pacman and system packages
- Installs and configures VMware tools with copy & paste support
- Installs hardware accelerated graphics (Mesa)
- Installs KDE Plasma desktop with selected applications
- Sets up AUR access and installs AUR packages

## Requirements

- Arch Linux with sudo access for current user
- Ansible installed: `sudo pacman -S ansible`
- Git: `sudo pacman -S git`

## Dry-run

Test run playbooks:

```
ansible-playbook -i inventory local-vm.yml -K --check -v
``` 

## Usage

Run all playbooks:

```bash
ansible-playbook -K local-vm.yml
```

Run specific roles:
```bash
ansible-playbook -K local-vm.yml --tags kde
ansible-playbook -K local-vm.yml --tags vmware
ansible-playbook -K local-vm.yml --tags aur
```

The `-K` flag prompts for sudo password.
