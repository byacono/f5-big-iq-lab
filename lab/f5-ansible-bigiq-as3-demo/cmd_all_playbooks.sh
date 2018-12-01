#!/bin/bash
# Uncomment set command below for code debugging bash
#set -x
# Uncomment set command below for code debugging ansible
#DEBUG_arg="-vvvv"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default value set to UDF
if [ -z "$2" ]; then
  env="udf"
else
  #env="sjc"
  #env="sjc2"
  #env="sea"
  env=$2
fi

echo -e "\nEnvironement:${RED} $env ${NC}\n"

# Usage
# Usage
if [[ -z $1 ]]; then
    echo -e "\nUsage: ${RED} $0 <pause/nopause> <udf/sjc/sjc2/sea> ${NC}\n"
    exit 1;
fi

echo -e "\nWarning: ${RED}Follow Task 8 from the lab guide (assign HTTPcustomTemplateTask6 template to Applicator Creator AS3 custom role and remove the **default** template from the allowed list).${NC}\n"

[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"

if [[  $env != "udf" ]]; then
    ansible-playbook -i inventory/$env-hosts .as3_bigiq_task1_create_http_app_$env.yml $DEBUG_arg
    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    sleep 15
    ansible-playbook -i inventory/$env-hosts .as3_bigiq_task2_create_https_app_$env.yml $DEBUG_arg
    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    sleep 15
    ansible-playbook -i inventory/$env-hosts .as3_bigiq_task3_create_waf_app_$env.yml $DEBUG_arg
    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    sleep 15
    ansible-playbook -i inventory/$env-hosts .as3_bigiq_task4_create_generic_app_$env.yml $DEBUG_arg
    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    sleep 15
    ansible-playbook -i inventory/$env-hosts .as3_bigiq_task5a_modify_post_http_app_$env.yml $DEBUG_arg
    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    sleep 15
    ansible-playbook -i inventory/$env-hosts .as3_bigiq_task5b_modify_patch_http_app_$env.yml $DEBUG_arg
    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    sleep 15
    ansible-playbook -i inventory/$env-hosts .as3_bigiq_task6_create_template_$env.yml $DEBUG_arg
    echo -e "\nWarning: ${RED}Follow Task 8 from the lab guide (assign HTTPcustomTemplateTask6 template to Applicator Creator AS3 custom role and remove the **default** template from the allowed list).${NC}\n"
    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    sleep 15
    ansible-playbook -i inventory/$env-hosts as3_bigiq_task8_create_http_app_$env.yml $DEBUG_arg
else
    ansible-playbook -i inventory/$env-hosts as3_bigiq_task1_create_http_app.yml $DEBUG_arg
    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    sleep 15
    ansible-playbook -i inventory/$env-hosts as3_bigiq_task2_create_https_app.yml $DEBUG_arg
    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    sleep 15
    ansible-playbook -i inventory/$env-hosts as3_bigiq_task3_create_waf_app.yml $DEBUG_arg
    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    sleep 15
    ansible-playbook -i inventory/$env-hosts as3_bigiq_task4_create_generic_app.yml $DEBUG_arg
    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    sleep 15
    ansible-playbook -i inventory/$env-hosts as3_bigiq_task5a_modify_post_http_app.yml $DEBUG_arg
    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    sleep 15
    ansible-playbook -i inventory/$env-hosts as3_bigiq_task5b_modify_patch_http_app.yml $DEBUG_arg
    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    sleep 15
    ansible-playbook -i inventory/$env-hosts as3_bigiq_task6_create_template.yml $DEBUG_arg
    echo -e "\nWarning: ${RED}Follow Task 8 from the lab guide (assign HTTPcustomTemplateTask6 template to Applicator Creator AS3 custom role and remove the **default** template from the allowed list).${NC}\n"
    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    sleep 15
    ansible-playbook -i inventory/$env-hosts as3_bigiq_task8_create_http_app.yml $DEBUG_arg
fi
