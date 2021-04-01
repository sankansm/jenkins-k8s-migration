#!/bin/bash
sudo apt update -y
sudo apt-get install unzip
wget https://releases.hashicorp.com/vault/1.3.1/vault_1.3.1_linux_amd64.zip
unzip vault_*.zip
sudo mv vault /usr/local/bin/
sudo setcap cap_ipc_lock=+ep /usr/local/bin/vault
sudo setcap cap_ipc_lock=+ep /usr/local/bin/vault
vault --version
sudo useradd -r -d /var/lib/vault -s /bin/nologin vault
sudo install -o vault -g vault -m 750 -d /var/lib/vault
sudo install -o vault -g vault -m 750 -d /var/lib/vault
sudo apt-get install awscli -y
sudo aws s3 cp s3://consultation-filesharing/vault/prod/vault.hcl /etc/
sudo chown vault:vault /etc/vault.hcl 
sudo chmod 640 /etc/vault.hcl
mkdir /vault
touch /vault/vault-audit.log
chown vault:vault /vault/vault-audit.log
sudo aws s3 cp s3://consultation-filesharing/vault/prod/vault.service /etc/systemd/system/
ip=`ifconfig | grep 'inet 10' | awk '{print $2}'`
sed -i -e "s/.*cluster_address.*/cluster_address  = \"$ip:8201\"/" /etc/vault.hcl
sed -i -e "s/.*api_addr.*/api_addr = \"http:$ip:8200\"/" /etc/vault.hcl
sed -i -e "s/.*cluster_addr.*/cluster_addr = \"http:$ip:8201\"/" /etc/vault.hcl
export VAULT_ADDR=http://localhost:8200
service vault restart
