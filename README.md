# Arch Linux VMware Setup

# 1. VMware Image Setup

## Get Arch Linux Image

- Get ISO and signature files from an official [Arch Linux Repo](https://archlinux.org/download/).
- Follow instructions to check checksums and signature.

## VMware Setup

- File > New Virtual Machine
- Virtual Machine Configuration: *Typical*
- Install operation system from: *Installer disc image file (iso)*
- Guest Operation System: *Linux*
- Kernel: *Other Linux 6.x kernel 64-bit*
- Name and location of VM.
- Disk Size:
    - *~150GB* (be generous)
    - *Store virutal disk as single file*
- Memory and Processor depend on host.

After completing the wizard, go to "Edit virtual machine settings":
**Hardware Tab**
- Display:
    - Accelerated 3D Graphics 
    - Strech mode and keep aspect ratio

**Options tab**
- Advanced > Firmware type: UEFI
- Guest isolation
    - Enable drag and drop
    - Enable copy and paste

Start the VM.

If keyboard input is very laggy, open `<vm-name>.vmx` in VM folder and add this line:

```{bash}
keyboard.vusb.enable = "TRUE" # no keyboard input lag
```

# 2. Archinstall

Open `archinstall` or manual installation (not described here).

# 3. Ansible

The ansible playbook covers post-installation configuration for Arch Linux in a VMware environment.

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
ansible-playbook -i inventory playbook-arch-vm.yml -K
```

Run specific roles, e.g.:
```bash
ansible-playbook -K playbook-arch-vm.yml --tags kde -v
ansible-playbook -K playbook-arch-vm.yml --tags pacman-update -v
```

For all available tags, check `ansible-playbook playbook-arch-vm.yml --list-tags`.

# 4. Troubleshooting


## Copy-paste issue with VMware

Copy-pasting from host to guest (VMware) or vice-versa does not work. 

* Issue: https://github.com/vmware/open-vm-tools/issues/792
* The clipboard sharing (copy & paste) and drag & drop between VMware host and guest do not function when the guest is running a Wayland session. open-vm-tools only supports copy & pasting in X11 sessions.


**Solution**:

Install patched version of Open VM Tools https://github.com/krisztianfekete/clipway

```{bash}
paru -S open-vm-tools-clipway

# Add to shell-rc-file
XDG_SESSION_TYPE=wayland vmtoolsd -n vmusr &
```
