#!/bin/bash
# Uncomment set command below for code debuging bash
# set -x

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

if [ -z "$1" ];then
        url="site40.example.com"
else
        url=$1
fi

echo -e "\nHTTPS app only.\nUsage: ./404.sh site40.example.com"

echo -e "\nTarget:${GREEN} $url ${NC}\n"

for i in {1..10};
do
        curl -k -s -m 10 -o /dev/null -w '404demo.php\tstatus: %{http_code}\tbytes: %{size_download}\ttime: %{time_total}\n' https://$url/404demo.php
        sleep 2;
done

echo -e "\n${BLUE}Attack completed.${NC}\n"