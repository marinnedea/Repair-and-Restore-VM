# Repair-and-Restore-VM
Azure CLI script to to create the repair environment for a VM and also to restore it post mitigation.

## Requires:	
* AzCli 2.0 installed on the machine you're running this script on			
**	https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest	

### NOTE: If enabled, you can also run it through the bash Cloud Shell in your Azure Portal page.	
* the vm-repair module installed in AzCLI 2.0

### More on the vm-repair module for AzCLI 2.0:
* https://docs.microsoft.com/en-us/cli/azure/ext/vm-repair/vm/repair?view=azure-cli-latest  
* https://tinyurl.com/urfketn     

## To enable the vm-repair module for AzCLI 2.0:
`az extension add -n vm-repair`       <-- this will install the vm-repair module in AzCLI2.0    
`az extension update -n vm-repair`    <-- this will update existing vm-repair module in AzCLI2.0  

## Usage:
1. `chmod +x repair_restore.sh`
2. `./repair_restore.sh create`
3. Provide the required info when prompted.
4. Connect to the rescue VM and fix the issue.
5. Once all fixed, back to az cli shell and run `./repair_restore.sh restore`  to restore your affecetd VM using the fixed disk.
6. Start the affected VM via Azure portal and check it's status.
