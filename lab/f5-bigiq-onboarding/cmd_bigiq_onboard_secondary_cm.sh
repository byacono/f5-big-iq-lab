#!/bin/bash
# Uncomment set command below for code debugging bash
#set -x
# Uncomment set command below for code debugging ansible
#DEBUG_arg="-vvvv"

# Default value set to UDF
if [ -z "$2" ]; then
  env="udf"
else
  #env="sjc"
  #env="sjc2"
  env=$2
fi

############################################################################################
# CONFIGURATION
ip_cm2="$(cat inventory/group_vars/$env-bigiq-cm-02.yml| grep bigiq_onboard_server | awk '{print $2}')"

declare -a ips=("$ip_cm2")
############################################################################################

function pause(){
   read -p "$*"
}

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Usage
if [[ -z $1 ]]; then
    echo -e "\nUsage: ${RED} $0 <pause/nopause> <udf/sjc/sjc2> ${NC} (1st parameter mandatory)\n"
    exit 1;
fi

# SECONDS used for total execution time (see end of the script)
SECONDS=0

echo -e "\nEnvironement:${RED} $env ${NC}\n"

echo -e "Exchange ssh keys with BIG-IQ & DCD:"
for ip in "${ips[@]}"; do
  echo "$ip"
  sshpass -p default ssh-copy-id -o StrictHostKeyChecking=no root@$ip > /dev/null 2>&1
done

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

echo -e "\n${GREEN}Install ansible-galaxy roles${NC}"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
ansible-galaxy install f5devcentral.bigiq_onboard --force

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

echo -e "\n${GREEN}Onboarding BIG-IQ CM secondary${NC}"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
if [[  $env == "udf" ]]; then
  ansible-playbook -i inventory/$env-hosts bigiq_onboard_secondary_cm.yml $DEBUG_arg
else
  ansible-playbook -i inventory/$env-hosts .bigiq_onboard_secondary_cm_$env.yml $DEBUG_arg
fi

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

### CUSTOMIZATION - F5 INTERNAL LAB ONLY
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"

# loop around the BIG-IQ CM/DCD
# enable ssh for admin and set-basic-auth on
for ip in "${ips[@]}"; do
  echo -e "\n---- ${RED} $ip ${NC} ----"
  echo -e "tmsh modify auth user admin shell bash"
  ssh -o StrictHostKeyChecking=no root@$ip tmsh modify auth user admin shell bash
  ssh -o StrictHostKeyChecking=no root@$ip set-basic-auth on
done

# disable ssl check for VMware SSG on the CM
ssh -o StrictHostKeyChecking=no root@$ip_cm1 << EOF
  echo >> /var/config/orchestrator/orchestrator.conf
  echo 'VALIDATE_CERTS = "no"' >> /var/config/orchestrator/orchestrator.conf
  bigstart restart gunicorn
EOF
  
echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

# total script execution time
echo -e "$(date +'%Y-%d-%m %H:%M'): elapsed time:${RED} $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec${NC}"