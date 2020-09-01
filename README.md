# Repair-and-Restore-VM
Azure CLI script to to create the repair environment for a VM and also to restore it post mitigation.


## Usage:

1. `chmod +x repair_restore.sh`
2. `./repair_restore.sh create`
3. Provide the required info when prompted.
4. Connect to the rescue VM and fix the issue.
5. Once all fixed, back to az cli shell and run `./repair_restore.sh restore`  to restore your affecetd VM using the fixed disk.
6. Start the affected VM via Azure portal and check it's status.
