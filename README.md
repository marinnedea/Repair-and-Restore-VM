
# Repair and Restore Virtual Machines

This script automates the processes of **repairing**, **restoring**, and **backing up** virtual machines (VMs) managed by libvirt. It is designed to provide robust error handling, detailed logging, and ease of use for system administrators.

## Features

- **Backup VMs**: Create compressed backups of VM disk images.
- **Restore VMs**: Restore VM disk images from a specified backup file.
- **Repair VMs**: Execute a custom repair script for a specified VM.
- **Detailed Logging**: All operations are logged with timestamps for easy debugging.
- **Modular Design**: Functions are cleanly separated for improved maintainability.

## Requirements

- Bash shell (v4.0 or higher)
- Root privileges
- libvirt-based VMs
- Pre-created directory for backups (default: `/var/backups/vms`)
- Custom VM repair script (optional, default location: `/usr/local/bin/repair_vm.sh`)

## Installation

1. Clone this repository:
    ```bash
    git clone https://github.com/marinnedea/Repair-and-Restore-VM.git
    cd Repair-and-Restore-VM
    ```

2. Make the script executable:
    ```bash
    chmod +x repair_restore.sh
    ```

3. Ensure the backup directory exists:
    ```bash
    sudo mkdir -p /var/backups/vms
    sudo chmod 700 /var/backups/vms
    ```

4. (Optional) Place your custom repair script at `/usr/local/bin/repair_vm.sh` and make it executable:
    ```bash
    sudo touch /usr/local/bin/repair_vm.sh
    sudo chmod +x /usr/local/bin/repair_vm.sh
    ```

## Usage

Run the script with the following syntax:

```bash
sudo ./repair_restore.sh {backup|restore|repair} VM_NAME [BACKUP_FILE]
```

### Commands

- **`backup`**: Create a compressed backup of the specified VM.
    ```bash
    sudo ./repair_restore.sh backup VM_NAME
    ```

- **`restore`**: Restore a VM from a specified backup file.
    ```bash
    sudo ./repair_restore.sh restore VM_NAME BACKUP_FILE
    ```

- **`repair`**: Run the custom repair script for the specified VM.
    ```bash
    sudo ./repair_restore.sh repair VM_NAME
    ```

### Examples

1. **Backup a VM**:
    ```bash
    sudo ./repair_restore.sh backup my_vm
    ```
    Backup is saved in `/var/backups/vms` with the filename format `my_vm_YYYY-MM-DD_HH-MM-SS.tar.gz`.

2. **Restore a VM from a backup**:
    ```bash
    sudo ./repair_restore.sh restore my_vm /var/backups/vms/my_vm_2024-11-30_12-00-00.tar.gz
    ```

3. **Repair a VM**:
    ```bash
    sudo ./repair_restore.sh repair my_vm
    ```
    Executes the custom repair script located at `/usr/local/bin/repair_vm.sh`.

## Configuration

- **Backup Directory**: Default is `/var/backups/vms`. Update the `BACKUP_DIR` variable in the script to change this.
- **Log File**: Default is `/var/log/repair_restore.log`. Update the `LOG_FILE` variable in the script to change this.
- **Custom Repair Script**: Default location is `/usr/local/bin/repair_vm.sh`. Update the `repair_vm` function in the script if your repair script is elsewhere.

## Logging

All operations are logged to `/var/log/repair_restore.log`. Logs include timestamps and detailed messages for each operation.

## Troubleshooting

- **Error: "This script must be run as root"**  
  Ensure you run the script with `sudo` or as the `root` user.

- **Error: "Backup file must be specified for restore"**  
  Provide the path to the backup file when using the `restore` command.

- **Error: "Repair script not found or not executable"**  
  Ensure the repair script exists and has executable permissions.

## Contribution

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Commit your changes and push them to your branch.
4. Create a pull request.

## License

This project is licensed under the [MIT License](LICENSE).
