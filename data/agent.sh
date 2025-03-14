#!/bin/bash

rpm -i /tmp/vagrant_data/wazuh-agent*.rpm

# Setup mitmproxy
curl https://downloads.mitmproxy.org/11.0.0/mitmproxy-11.0.0-linux-x86_64.tar.gz -o /tmp/mitmproxy.tar.gz
tar -zxf /tmp/mitmproxy.tar.gz -C /usr/local/bin

## turn off firewalld
systemctl stop firewalld
systemctl disable firewalld
