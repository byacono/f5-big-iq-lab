#!/bin/bash
# Uncomment set command below for code debuging bash
#set -x

echo -e "\nTIME: $(date +"%H:%M")"

cd /home/f5/vmware-ansible

# Get list of VMs in the vCenter
ansible-playbook -i notahost, get_status_vm.yaml

# parse JSON and filter only the uuid
jq '.virtual_machines' vmfact.json | grep uuid | awk -F: '{print $2}' | sed -n 's/^.*"\(.*\)".*$/\1/p' > uuid.txt

# count number of VMs
n=$(wc -l uuid.txt | awk '{ print $1 }')

# if VM = 1, it means there is only the vCenter running so no need to run the power on playbook.
if [ "$n" -gt "1" ]; then
    while IFS= read -r uuid
    do
        echo -e "\n#### $uuid"
        # power on SSG VMs
        ansible-playbook -i notahost, power_on_vm.yaml --extra-vars "uuid=$uuid"
    done < uuid.txt
else
    echo "No SSG VM(s) to power on."
fi

rm -f vmfact.json uuid.txt