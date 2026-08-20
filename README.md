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
ansible-playbook -i inventory playbook-arch-vm.yml -K --check -v
``` 

## Usage

Run all playbooks:

```bash
ansible-playbook -K playbook-arch-vm.yml -v
```

Run specific roles, e.g.:
```bash
ansible-playbook -K playbook-arch-vm.yml --tags kde -v
ansible-playbook -K playbook-arch-vm.yml --tags pacman-update -v
```

For all available tags, check `ansible-playbook playbook-arch-vm.yml --list-tags`.


