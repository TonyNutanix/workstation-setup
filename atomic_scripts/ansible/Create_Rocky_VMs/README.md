# Deploy Rocky Linux 9 VM on Nutanix AHV

Ansible playbook that creates and powers on a Rocky Linux 9 VM on Nutanix AHV via Prism Central API, with cloud-init guest customization.

## What It Does

1. **Pre-flight validation** — confirms all required credentials and config vars are present
2. **Image upload** *(optional)* — downloads the Rocky 9 GenericCloud qcow2 to Nutanix Image Service if a source URL is provided
3. **VM creation** — provisions the VM with specified vCPU, memory, disk, and networking
4. **Cloud-init** — injects hostname, SSH key, user account, and installs qemu-guest-agent
5. **Power on** — starts the VM after creation
6. **Summary output** — prints the VM UUID and configuration

## Prerequisites

- Ansible >= 2.14
- Python >= 3.9
- Network access to Prism Central / Prism Element

## Quick Start

```bash
# 1. Install the Nutanix Ansible collection
ansible-galaxy collection install -r requirements.yml

# 2. Edit your credentials (then vault-encrypt)
vim vars/nutanix_credentials.yml
ansible-vault encrypt vars/nutanix_credentials.yml

# 3. Edit VM config to match your environment
vim vars/vm_config.yml

# 4. Deploy
ansible-playbook deploy_rocky9_vm.yml \
  -e "@vars/nutanix_credentials.yml" \
  --ask-vault-pass
```

## File Structure

```
.
├── ansible.cfg                    # Ansible settings (timeout, callbacks)
├── deploy_rocky9_vm.yml           # Main playbook
├── requirements.yml               # Galaxy collection dependency
├── README.md
└── vars/
    ├── nutanix_credentials.yml    # Prism Central creds (vault-encrypt this)
    └── vm_config.yml              # VM specs, networking, cloud-init
```

## Configuration Reference

### Required Changes in `vars/vm_config.yml`

| Variable | Description |
|---|---|
| `nutanix_cluster_name` | Your AHV cluster name as shown in Prism |
| `nutanix_subnet_name` | Target subnet/VLAN for the VM NIC |
| `cloud_init_ssh_pubkey` | Your SSH public key for the `ansible` user |

### Optional Tuning

| Variable | Default | Description |
|---|---|---|
| `vm_vcpus` | `2` | Number of virtual CPUs |
| `vm_memory_gb` | `4` | RAM in GB |
| `vm_disk_size_gb` | `50` | OS disk size (auto-grows via cloud-init) |
| `vm_static_ip` | *(DHCP)* | Set for static IP assignment |
| `vm_boot_type` | `LEGACY` | `LEGACY` or `UEFI` |
| `rocky9_image_url` | Rocky 9 cloud URL | Comment out if image already uploaded |

## Deploying Multiple VMs

Override `vm_name` on the command line:

```bash
ansible-playbook deploy_rocky9_vm.yml \
  -e "@vars/nutanix_credentials.yml" \
  -e "vm_name=rocky9-web-01 vm_static_ip=10.0.0.101" \
  --ask-vault-pass
```

Or loop with a simple wrapper script or inventory-driven approach.

## Destroying a VM

```bash
ansible-playbook deploy_rocky9_vm.yml \
  -e "@vars/nutanix_credentials.yml" \
  -e "vm_name=rocky9-server-01" \
  -e "vm_state=absent" \
  --ask-vault-pass
```

*(Requires adding a `state: "{{ vm_state | default('present') }}"` pattern to the playbook — left as `present` by default for safety.)*

## Troubleshooting

- **`nutanix.ncp` not found** — run `ansible-galaxy collection install -r requirements.yml`
- **SSL errors** — set `nutanix_validate_certs: false` in vm_config.yml (lab only)
- **Image upload timeout** — increase `timeout` in ansible.cfg; large images take time
- **VM creation fails with subnet error** — verify `nutanix_subnet_name` matches exactly as shown in Prism > Network Configuration
