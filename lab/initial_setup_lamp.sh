#!/bin/bash

# Ubuntu 18.04 Lamp Server, RDP, Radius, Docker
# Use Xubuntu Jumpbox v17 as a baseline in UDF
# vCPUs: 2
# Memory: 2 GiB
# Disk Size: 60 GiB
# Networking Limits
# Interfaces: 10

# Initial script install:
# sudo su - 
# curl -O https://raw.githubusercontent.com/f5devcentral/f5-big-iq-lab/develop/lab/initial_setup_lamp.sh
# chmod +x /root/initial_setup_lamp.sh
# ./initial_setup_lamp.sh

# Run as root in /root

function pause(){
   read -p "$*"
}

cd /root

read -p "Configure Network? (Y/N) (Default=N): " answer
if [[  $answer == "Y" ]]; then
    # Configure Network
    echo 'network:
  ethernets:
    eth0:
        addresses:
            - 10.1.1.5/24
        gateway4: 10.1.1.2
        nameservers:
          addresses: [10.1.1.1]
    eth2:
        addresses:
            - 10.1.20.5/24
            - 10.1.20.110/24
            - 10.1.20.111/24
            - 10.1.20.112/24
            - 10.1.20.113/24
            - 10.1.20.114/24
            - 10.1.20.115/24
            - 10.1.20.116/24
            - 10.1.20.117/24
            - 10.1.20.118/24
            - 10.1.20.119/24
            - 10.1.20.120/24
            - 10.1.20.121/24
            - 10.1.20.122/24
            - 10.1.20.123/24
            - 10.1.20.124/24
            - 10.1.20.125/24
            - 10.1.20.126/24
            - 10.1.20.127/24
            - 10.1.20.128/24
            - 10.1.20.129/24
            - 10.1.20.130/24
            - 10.1.20.131/24
            - 10.1.20.132/24
            - 10.1.20.133/24
            - 10.1.20.134/24
            - 10.1.20.135/24
            - 10.1.20.136/24
            - 10.1.20.137/24
            - 10.1.20.138/24
            - 10.1.20.139/24
            - 10.1.20.140/24
            - 10.1.20.141/24
            - 10.1.20.142/24
            - 10.1.20.143/24
            - 10.1.20.144/24
            - 10.1.20.145/24
            - 10.1.20.146/24
    eth1:
        addresses:
            - 10.1.10.5/24' > /etc/netplan/01-netcfg.yaml
fi

read -p "Perform Ubuntu Upgrade 17.04 to 17.10? (Y/N) (Default=N): " answer
if [[  $answer == "Y" ]]; then
    echo 'deb http://archive.ubuntu.com/ubuntu artful main restricted
    deb-src http://archive.ubuntu.com/ubuntu artful main restricted

    deb http://archive.ubuntu.com/ubuntu artful-updates main restricted
    deb-src http://archive.ubuntu.com/ubuntu artful-updates main restricted

    deb http://archive.ubuntu.com/ubuntu artful universe
    deb-src http://archive.ubuntu.com/ubuntu artful universe
    deb http://archive.ubuntu.com/ubuntu artful-updates universe
    deb-src http://archive.ubuntu.com/ubuntu artful-updates universe

    deb http://archive.ubuntu.com/ubuntu artful multiverse
    deb-src http://archive.ubuntu.com/ubuntu artful multiverse
    deb http://archive.ubuntu.com/ubuntu artful-updates multiverse
    deb-src http://archive.ubuntu.com/ubuntu artful-updates multiverse

    deb http://archive.ubuntu.com/ubuntu artful-backports main restricted universe multiverse
    deb-src http://archive.ubuntu.com/ubuntu artful-backports main restricted universe multiverse

    deb http://security.ubuntu.com/ubuntu artful-security main restricted
    deb-src http://security.ubuntu.com/ubuntu artful-security main restricted
    deb http://security.ubuntu.com/ubuntu artful-security universe
    deb-src http://security.ubuntu.com/ubuntu artful-security universe
    deb http://security.ubuntu.com/ubuntu artful-security multiverse
    deb-src http://security.ubuntu.com/ubuntu artful-security multiverse' > /etc/apt/sources.list

    lsb_release -a 
    apt update
    export DEBIAN_FRONTEND=noninteractive
    apt --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade -y
    apt --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade -y
    apt autoremove -y
    lsb_release -a

    read -p "Reboot? (Y/N) (Default=N): " answer
    if [[  $answer == "Y" ]]; then
        init 6
    fi
fi

lsb_release -a

read -p "Perform Ubuntu Upgrade 17.10 to 18.04? (Y/N) (Default=N): " answer
if [[  $answer == "Y" ]]; then
    apt update
    export DEBIAN_FRONTEND=noninteractive
    apt --fix-broken install -y
    do-release-upgrade -f DistUpgradeViewNonInteractive
    apt autoremove -y
    lsb_release -a

    read -p "Reboot? (Y/N) (Default=N): " answer
    if [[  $answer == "Y" ]]; then
        init 6
    fi
fi

lsb_release -a

read -p "Perform Ubuntu Post Upgrade task 18.04? (Y/N) (Default=N):" answer
if [[  $answer == "Y" ]]; then
    apt update
    export DEBIAN_FRONTEND=noninteractive
    apt --fix-broken -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install -y
    apt -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade -y
    apt -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade -y
    apt autoremove -y
    lsb_release -a

    read -p "Reboot? (Y/N) (Default=N): " answer
    if [[  $answer == "Y" ]]; then
        init 6
    fi
fi

echo -e "Cleanup unnessary packages"
apt --purge remove apache2 chromium-browser -y
apt autoremove -y

echo -e "\nIP config check"
ip addr

echo -e "\nInstall Docker"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt install docker-ce -y
/etc/init.d/docker status

echo -e "\nInstall DHCP service"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
apt -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install isc-dhcp-server -y
echo 'INTERFACES="eth0"' > /etc/default/isc-dhcp-server
echo 'default-lease-time 600;
max-lease-time 7200;

subnet 10.1.1.0 netmask 255.255.255.0 {
option routers                  10.1.1.1;
option subnet-mask              255.255.255.0;
option domain-search            "example.com";
option domain-name-servers      8.8.8.8;
range   10.1.1.220   10.1.1.250;
}' > /etc/dhcp/dhcpd.conf
/etc/init.d/isc-dhcp-server restart
/etc/init.d/isc-dhcp-server status
dhcp-lease-list --lease /var/lib/dhcp/dhcpd.leases

echo -e "\nInstall Radius service"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
apt install freeradius -y
freeradius –v
echo 'paula   Cleartext-Password := "paula"
paul    Cleartext-Password := "paul"
marco   Cleartext-Password := "marco"
larry   Cleartext-Password := "larry"
david   Cleartext-Password := "david"' >> /etc/freeradius/3.0/users

echo 'client 0.0.0.0/0 {
secret = default
shortname = bigiq
}' >> /etc/freeradius/3.0/radiusd.conf
/etc/init.d/freeradius restart
/etc/init.d/freeradius status

echo -e "\nInstall Apache Benchmark, Git, SNMPD"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
apt install apache2-utils -y
apt install git -y
apt install snmpd snmptrapd -y

echo -e "\nInstall Ansible and sshpass"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
apt install software-properties-common -y
add-apt-repository ppa:ansible/ansible -y
apt update
apt install ansible -y
apt install sshpass -y
ansible-playbook --version

echo -e "\nInstall Postman"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
apt install cdcat libqt5core5a libqt5network5 libqt5widgets5 -y 
wget https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz
tar -xzf postman.tar.gz -C /opt
rm postman.tar.gz
sudo ln -s /opt/Postman/Postman /usr/bin/postman

echo -e "\nInstall DNS perf"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
apt install libbind-dev libkrb5-dev libssl-dev libcap-dev libxml2-dev -y
apt install gzip curl make gcc bind9utils libjson-c-dev libgeoip-dev -y
wget ftp://ftp.nominum.com/pub/nominum/dnsperf/2.0.0.0/dnsperf-src-2.0.0.0-1.tar.gz
tar xfvz dnsperf-src-2.0.0.0-1.tar.gz
cd dnsperf-src-2.0.0.0-1
./configure
make
make install
rm -f dnsperf-src-2.0.0.0-1.tar.gz

echo -e "\nInstall Chrome"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb

echo -e "\nInstall Azure CLI"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
tee /etc/apt/sources.list.d/azure-cli.list
# Get the Microsoft signing key:
curl -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
# Install the CLI:
apt update
apt install apt-transport-https azure-cli -y

echo -e "\nCustomisation Users"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
ln -snf /home/f5student /home/f5
chown -R f5student:f5student /home/f5
echo 'f5student ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# some cleanup
cd /home/f5student
rm -rf AVR\ Demo.jmx hackazon* AB_DOS.sh baseline_menu.sh jmeter.log scripts dos30.sh Templates Documents source Desktop/putty.desktop Desktop/wireshark.desktop Desktop/Notes* Desktop/DoS3_0.desktop Desktop/jmeter.desktop Desktop/chromium-browser.desktop /home/f5student/.config/Postman/* Downloads/*
rmdir /home/f5student/*
mkdir rmdir /home/f5student/Downloads
rm -rf /root/scripts
# Reset user's password
yes purple123 | passwd f5student

# bashrc config
echo 'cd /home/f5student
echo
sudo docker images;
echo
sudo docker ps
echo
echo "To run Kali Linux Docker Image: sudo docker run -t -i kalilinux/kali-linux-docker /bin/bash"
echo "(run apt update && apt install metasploit-framework after starting Kali Linux)"
echo
echo "To connect to a docker instance: sudo docker exec -i -t <Container ID> /bin/bash"
echo
echo -e "To get the latest tools/scripts, execute: ./update_git.sh"
echo
sudo su - f5student' >> /home/ubuntu/.bashrc

# customize vim
echo 'let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction' > /root/.vimrc
cp /root/.vimrc /home/ubuntu/.vimrc
cp /root/.vimrc /home/f5student/.vimrc
chown ubuntu:ubuntu /home/ubuntu/.vimrc
chown f5student:f5student /home/f5student/.vimrc

# Add links on f5student desktop
echo '[Desktop Entry]
Version=1.0
Name=Google Chrome
GenericName=Web Browser
Comment=Access the Internet
Exec=/usr/bin/google-chrome-stable %U
StartupNotify=true
Terminal=false
Icon=google-chrome
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml_xml;image/webp;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;
Actions=new-window;new-private-window;

[Desktop Action new-window]
Name=New Window
Exec=/usr/bin/google-chrome-stable

[Desktop Action new-private-window]
Name=New Incognito Window
Exec=/usr/bin/google-chrome-stable --incognito' > /home/f5student/Desktop/google-chrome.desktop

echo '[Desktop Entry]
Version=1.0
Type=Application
Exec=exo-open --launch TerminalEmulator
Icon=utilities-terminal
StartupNotify=true
Terminal=false
Categories=Utility;X-XFCE;X-Xfce-Toplevel;
OnlyShowIn=XFCE;
Name=Terminal Emulator
Comment=Use the command line' > /home/f5student/Desktop/exo-terminal-emulator.desktop

curl -O https://www.logolynx.com/images/logolynx/19/191dac9f3656d7c08de542b49e827f39.png
mv 191dac9f3656d7c08de542b49e827f39.png /home/f5student/Downloads/vcenter_logo.png

echo '[Desktop Entry]
Version=1.0
Type=Link
Name=vCenter
Comment=
Icon=/home/f5student/Downloads/vcenter_logo.png
URL=https://10.1.1.90/ui' > /home/f5student/Desktop/vCenter.desktop

curl -O https://www.getpostman.com/img/v2/logo-glyph.png
mv logo-glyph.png /home/f5student/Downloads/postman_logo.png

echo '[Desktop Entry]
Version=1.0
Type=Application
Name=postman
Comment=
Exec=/usr/bin/postman
Icon=/home/f5student/Downloads/postman_logo.png
Path=
Terminal=false
StartupNotify=false' > /home/f5student/Desktop/Postman_postman.desktop

chmod +x /home/f5student/Desktop/*.desktop

# WA Chrome always ask for keyring
rm /home/f5student/.local/share/keyrings/*
rm /var/crash/*

echo -e "\nSystem customisation (e.g. host file)"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
echo '10.1.10.70 site70.example.com
10.1.10.110 site10.example.com
10.1.10.111 site11.example.com
10.1.10.112 site12.example.com
10.1.10.113 site13.example.com
10.1.10.114 site14.example.com
10.1.10.115 site15.example.com
10.1.10.116 site16.example.com
10.1.10.117 site17.example.com site17auth.example.com
10.1.10.118 site18.example.com
10.1.10.119 site19.example.com site19auth.example.com
10.1.10.120 site20.example.com
10.1.10.121 site21.example.com site21auth.example.com
10.1.10.122 site22.example.com
10.1.10.123 site23.example.com
10.1.10.124 site24.example.com
10.1.10.125 site25.example.com
10.1.10.126 site26.example.com
10.1.10.127 site27.example.com
10.1.10.128 site28.example.com
10.1.10.129 site29.example.com
10.1.10.130 site30.example.com
10.1.10.131 site31.example.com
10.1.10.132 site32.example.com
10.1.10.133 site33.example.com
10.1.10.134 site34.example.com
10.1.10.135 site35.example.com
10.1.10.136 site36.example.com
10.1.10.137 site37.example.com
10.1.10.138 site38.example.com
10.1.10.139 site39.example.com
10.1.10.140 site40.example.com
10.1.10.141 site41.example.com
10.1.10.142 site42.example.com
10.1.10.143 site43.example.com
10.1.10.144 site44.example.com
10.1.10.145 site45.example.com' >> /etc/hosts

hostnamectl set-hostname xjumpbox

echo -e "\nInstall and execution of update_git.sh"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
echo "6.1.0" > /home/f5/bigiq_version_aws
#echo "6.0.1" > /home/f5/bigiq_version_aws

echo '#!/bin/sh -e

curl -o /home/f5student/update_git.sh https://raw.githubusercontent.com/f5devcentral/f5-big-iq-lab/develop/lab/update_git.sh
/home/f5student/update_git.sh > /home/f5student/update_git.log
chown -R f5student:f5student /home/f5student

hostnamectl set-hostname xjumpbox

exit 0' > /etc/rc.local
chmod +x /etc/rc.local

curl -O https://raw.githubusercontent.com/f5devcentral/f5-big-iq-lab/develop/lab/update_git.sh
chown f5student:f5student /home/f5student/update_git.sh
chmod +x /home/f5student/update_git.sh

/home/f5student/update_git.sh
chown -R f5student:f5student /home/f5student
killall sleep

echo -e "\nInstall AWS CLI"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
apt install python-pip -y
pip --version
cd /home/f5student/AWS-Cloud-Edition
ansible-playbook 01a-install-pip.yml

echo -e "\nInstall PyVmomi for VMware ansible playbooks"
su - f5student -c "sudo pip install PyVmomi"

echo -e "\nSSH keys exchanges between Lamp server and BIG-IP SEA and BIG-IQ CM"
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
ssh-copy-id -o StrictHostKeyChecking=no admin@10.1.1.7 
ssh-copy-id -o StrictHostKeyChecking=no admin@10.1.1.4

## Add there things to do manually
echo -e "\nPost-Checks:
- Test Reboot (init 6)
- Test HTTP traffic is showing on BIG-IQ
- Test Access traffic is showing on BIG-IQ
- Test DNS traffic is showing on BIG-IQ
- Test Radius user can connect on BIG-IQ
- Test VMware SSG working using DHCP
- Test VMware Ansible playbook
- Test AWS and Azure playbooks
- Test Connection to RDP
- Test Launch Chrome & Firefox
- Add bookmark of the BIG-IQ CE lab guide
- Remove bottom task bar (click right, properties, remove)
- Add postman collection, disable SSL in postman\n"

exit 0