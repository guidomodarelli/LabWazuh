#!/bin/bash

dpkg -i /tmp/vagrant_data/wazuh-agent*.deb

# Setup mitmproxy
curl https://downloads.mitmproxy.org/11.0.0/mitmproxy-11.0.0-linux-x86_64.tar.gz -o /tmp/mitmproxy.tar.gz
tar -zxf /tmp/mitmproxy.tar.gz -C /usr/local/bin
