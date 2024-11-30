#!/bin/bash

#########################################################################################################
# Title:  	Repair and restore Azure VM				                                #
# Author: 	Marin Nedea and Ibrahim Abedalghafer							#
# Created: 	March 5th, 2020									        #
# Last Update:  Nov 30th, 2024							                       #
# Usage:  	Just run the script with sh (e.g. sh script.sh)                                		#
# Requires:	AzCli 2.0 installed on the machine you're running this script on			#
# 		https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest	#
# 		If enabled, you can run it through the bash Cloud Shell in your Azure Portal page.	#
#           vm-repair module for AzCLI 2.0:                                                             #
#           - https://docs.microsoft.com/en-us/cli/azure/ext/vm-repair/vm/repair?view=azure-cli-latest  #
#           - https://tinyurl.com/urfketn                                                               #
#########################################################################################################
#           az extension add -n vm-repair     <-- this will install the vm-repair module in AzCLI2.0    #
#           az extension update -n vm-repair  <-- this will update the vm-repair module in AzCLI2.0     #
#########################################################################################################

set -euo pipefail

# Default Configuration
BACKUP_DIR="/var/backups/vms"
LOG_FILE="/var/log/repair_restore.log"
VM_CONFIG_FILE="/etc/vm_config"
CURRENT_DATE=$(date +"%Y-%m-%d_%H-%M-%S")

# Functions
log() {
    local message="$1"
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $message" | tee -a "$LOG_FILE"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log "Error: This script must be run as root."
        exit 1
    fi
}

backup_vm() {
    local vm_name="$1"
    local backup_path="${BACKUP_DIR}/${vm_name}_${CURRENT_DATE}.tar.gz"

    log "Starting backup for VM: $vm_name"
    if tar -czf "$backup_path" "/var/lib/libvirt/images/${vm_name}.qcow2"; then
        log "Backup for VM $vm_name completed: $backup_path"
    else
        log "Error: Backup for VM $vm_name failed."
        exit 1
    fi
}

restore_vm() {
    local vm_name="$1"
    local backup_path="$2"

    log "Restoring VM $vm_name from backup: $backup_path"
    if tar -xzf "$backup_path" -C "/var/lib/libvirt/images/"; then
        log "VM $vm_name restored successfully."
    else
        log "Error: Restore failed for VM $vm_name."
        exit 1
    fi
}

repair_vm() {
    local vm_name="$1"
    local repair_script="/usr/local/bin/repair_vm.sh"

    if [[ -f "$repair_script" && -x "$repair_script" ]]; then
        log "Running repair script for VM: $vm_name"
        if "$repair_script" "$vm_name"; then
            log "VM $vm_name repaired successfully."
        else
            log "Error: Repair script failed for VM $vm_name."
            exit 1
        fi
    else
        log "Error: Repair script not found or not executable."
        exit 1
    fi
}

usage() {
    echo "Usage: $0 {backup|restore|repair} VM_NAME [BACKUP_FILE]"
    exit 1
}

# Main Script Logic
check_root

if [[ $# -lt 2 ]]; then
    usage
fi

COMMAND="$1"
VM_NAME="$2"
BACKUP_FILE="${3:-}"

case "$COMMAND" in
    backup)
        backup_vm "$VM_NAME"
        ;;
    restore)
        if [[ -z "$BACKUP_FILE" ]]; then
            log "Error: Backup file must be specified for restore."
            usage
        fi
        restore_vm "$VM_NAME" "$BACKUP_FILE"
        ;;
    repair)
        repair_vm "$VM_NAME"
        ;;
    *)
        log "Error: Invalid command."
        usage
        ;;
esac
