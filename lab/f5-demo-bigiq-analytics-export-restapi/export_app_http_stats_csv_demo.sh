#!/bin/bash
# Uncomment set command below for code debugging bash
#set -x

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

if [ -z "$1" ]; then
  env="udf"
  user="f5student"
  bigiq="10.1.1.4"
  bigiq_user="admin"
  bigiq_password="purple123"
else
  env=$1
  user="f5"
  if [[  $env == "sjc" ]]; then
    bigiq="10.192.75.180"
  fi
  if [[  $env == "sjc2" ]]; then
    bigiq="10.192.75.185"
  fi
  bigiq_user="admin"
  bigiq_password="admin"
fi

# Usage
if [[ -z $1 ]]; then
    echo -e "\nUsage: ${RED} $0 <virtual> <from> <to> <duration> <udf/sjc/sjc2>${NC}\n"
    echo -e "Example: ./$0 \"/ecommerce/site15waf/serviceMain\" -P1H now 30"
    exit 1;
fi

# SJC2: virtual="/sanjose1site1/MyWebApp215/serviceMain"

# If no from/to/duration not specified, set default values
if [[ -z $2 ]]; then
    from="-P1H"
    to="now"
    duration="30" # in SECONDS
fi

echo -e "Environement:${RED} $env ${NC}"

# BIG-IQ must be configured for basic auth, in the console run `set-basic-auth on`

body="{
    \"kind\": \"ap:query:stats:byTime\",
    \"source\": \"bigip\",
    \"module\": \"http\",
    \"timeRange\": {
      \"from\": \"$from\",
        \"to\": \"$to\"
    },
    \"timeGranularity\": {
        \"duration\": $duration,
        \"unit\": \"SECONDS\"
    },
    \"aggregations\": {
        \"transactions\$avg-count-per-sec\": {
            \"metricSet\": \"transactions\",
            \"metric\": \"avg-count-per-sec\"
        },
        \"transaction-request-size\$avg-value-per-sec\": {
            \"metricSet\": \"transaction-request-size\",
            \"metric\": \"avg-value-per-sec\"
        },
        \"transaction-response-size\$avg-value-per-sec\": {
            \"metricSet\": \"transaction-response-size\",
            \"metric\": \"avg-value-per-sec\"
        }
    },
    \"dimensionFilter\": {
        \"type\": \"and\",
        \"args\": [
            {
                \"type\": \"eq\",
                \"dimension\": \"virtual\",
                \"value\": \"$virtual\"
            }
        ]
    }
}"

# Get the analytics data in JSON
curl --silent --output tmp.json -k \
    -H "Accept: application/json" \
    -H "Content-Type:application/json" \
    -X POST --data "$body" "https://$bigiq_user:$bigiq_password@$bigiq/mgmt/ap/query/v1/tenants/default/products/local-traffic/metric-query"

cat tmp.json | jq .result > input.json
rm tmp.json

# Install json2csv tool
if [ ! -d "json2csv" ]; then
    git clone https://github.com/evidens/json2csv.git
    sudo pip install -r json2csv/requirements.txt
fi

# Convert JSON to CSV
if [ -s input.json ]; then
    cd json2csv
    python json2csv.py ../input.json ../outline.json -o ../output.csv
    cd ..
fi

# Adding header
sed -i '1 i\time,transactions-avg-count-per-sec,transaction-request-size-avg-value-per-sec,transaction-response-size-avg-value-per-sec' output.csv

