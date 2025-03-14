#!/bin/bash

# Install
rpm -i /tmp/vagrant_data/wazuh-indexer*.rpm
rpm -i /tmp/vagrant_data/wazuh-dashboard*.rpm
rpm -i /tmp/vagrant_data/wazuh-server*.rpm

# Setup

## Create certs
mkdir certs
cd certs
bash /tmp/vagrant_data/gencerts.sh .

mkdir -p /etc/wazuh-indexer/certs
cp admin.pem  /etc/wazuh-indexer/certs/admin.pem
cp admin.key /etc/wazuh-indexer/certs/admin-key.pem
cp indexer.pem  /etc/wazuh-indexer/certs/indexer.pem
cp indexer-key.pem /etc/wazuh-indexer/certs/indexer-key.pem
cp ca.pem /etc/wazuh-indexer/certs/root-ca.pem
chown -R wazuh-indexer.wazuh-indexer /etc/wazuh-indexer/certs/

mkdir -p /etc/wazuh-dashboard/certs
cp dashboard.pem  /etc/wazuh-dashboard/certs/dashboard.pem
cp dashboard-key.pem /etc/wazuh-dashboard/certs/dashboard-key.pem
cp ca.pem /etc/wazuh-dashboard/certs/root-ca.pem
chown -R wazuh-dashboard.wazuh-dashboard /etc/wazuh-dashboard/certs/

cp comms.pem  /etc/wazuh-server/certs/server.cert
cp comms.key /etc/wazuh-server/certs/server.key
cp admin.pem  /etc/wazuh-server/certs/admin.pem
cp admin.key /etc/wazuh-server/certs/admin-key.pem
cp jwt-private.pem  /etc/wazuh-server/certs/private-key.pem
cp jwt-public.pem /etc/wazuh-server/certs/public-key.pem
cp ca.pem /etc/wazuh-server/certs/server.ca

chown -R wazuh-server:wazuh-server /etc/wazuh-server/certs/*

systemctl daemon-reload

## set up  indexer
systemctl enable wazuh-indexer
systemctl start wazuh-indexer
/usr/share/wazuh-indexer/bin/indexer-security-init.sh

## set up dashboard
systemctl enable wazuh-dashboard
systemctl start wazuh-dashboard

## enable ipv6
modprobe ipv6
sysctl -w net.ipv6.conf.all.disable_ipv6=0

## set up server
cp /tmp/vagrant_data/wazuh-server.yml /etc/wazuh-server/
systemctl enable wazuh-server
systemctl start wazuh-server

## turn off firewalld
systemctl stop firewalld
systemctl disable firewalld
