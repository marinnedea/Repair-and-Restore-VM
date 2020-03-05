#!/bin/bash

#########################################################################################################
# Title:  	Repair and restore Azure VM				                                #
# Author: 	Marin Nedea and Ibrahim Abedalghafer							#
# Created: 	March 5th, 2020									        #
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

echo "Do you wish to start rescue or restore a VM? [rescue/restore] [ENTER]:"
read options

if [ ! -z $options ]
then

        if [ $options == "rescue" ]
        then
	
		echo "Type the subscription ID that you want to use, followed by [ENTER]:"
		read sID

		echo "Type the affected VM resource group name [ENTER]:"
		read rg_name

		echo "Type the affected VM name [ENTER]:"
		read vm_name
		az account set --subscription $sID
		
                echo -e "$sID \n $rg_name \n $vm_name" > /tmp/rescue.data
                touch /tmp/repair
                touch /tmp/vmdetails
                echo "" > /tmp/repair
                az vm repair create -g $rg_name  -n  $vm_name --verbose  2>&1 | tee /tmp/repair

                count=0
                cat /tmp/repair | grep "repair_vm_name\|repair_resource_group" | awk -F" " '{gsub(/"/, "",  $2); gsub(/,/, "",  $2);  print $2}' | while read line; do
                        count=$(($count+1))
                        if [ $count == 1 ]
                        then
                        rg_repair="$(echo $line | awk '{print $0}')"
                        continue
                        fi
                        vm_repair="$(echo $line | awk '{print $0}')"
                       vmip="$(az vm show -d -g $rg_repair -n $vm_repair --query publicIps -o tsv)"
					   echo "Use the IP $vmip to connect to the VM!"
					   
                done

        elif [ $options == "restore" ]
        then
				count=0
                cat /tmp/rescue.data | while read line; do
				count=$(($count+1))
                if [ $count == 1 ]
                then
                sID="$(echo $line | awk '{print $0}')"
				continue
                fi
				if [ $count == 2 ]
                then		
                rg_name="$(echo $line | awk '{print $0}')"
				continue
                fi
                vm_name="$(echo $line | awk '{print $0}')"

                az account set --subscription $sID
                az vm repair restore -g $rg_name  -n  $vm_name --verbose
                done
        fi
else
        echo "Please provide some options!"
exit 0
fi
