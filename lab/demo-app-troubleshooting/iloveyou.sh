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
if [ -z "$2" ]; then
        client="213.187.116.138"
else
        client=$2
fi

echo "\nUsage: ./iloveyou.sh site40.example.com 213.187.116.138"

echo -e "\nTarget:${GREEN} $url ${NC}- Source:${RED} $client ${NC}\n"

for ((n=0;n<5;n++));
do
        curl -k -s -m 10 -o /dev/null --header "X-Forwarded-For: $client" -A "Mozilla/5.0 (compatible; MSIE 7.01; Windows NT 5.0)" -w "iloveyou.exe\tstatus: %{http_code}\tbytes: %{size_download}\ttime: %{time_total} source ip: $client url: $url\n" https://$url/iloveyou.exe
        sleep 2;
done

echo -e "\n${BLUE}Attack completed.${NC}\n"