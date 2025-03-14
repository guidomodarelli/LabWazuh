The idea is to create a quick environment to test the new Wazuh v5.

Two machines using RHEL 9 are used.

- server: with the server, indexer and dashboard
- agent: with the agent and the mitmproxy

It works on windows hyperv and virtualbox.
The RHEL images come from [roboxes.org](https://roboxes.org/)

To test the environment:

Copy your packages (indexer,dashboard,server and agent) into the date folder
Run bring it up with vagrant:

vagrant up --provider hyperv

On reboot /run is cleaned up, so we must create some files deployed
by the installer but not recreated while starting the service.

[root@rhel-server ~]# du -a /run/wazuh-server/
0       /run/wazuh-server/cluster
0       /run/wazuh-server/socket
0       /run/wazuh-server/

mkdir -p /run/wazuh-server/cluster
mkdir -p /run/wazuh-server/socket
chown -R wazuh.wazuh /run/wazuh-server

# run engine

systemctl restart wazuh-server
/usr/share/wazuh-server/bin/wazuh-engine

# mitmproxy

Communication between server and indexer
server # mitmproxy --mode reverse:https://localhost:9200@8080

Communication between agent and server
agent # mitmproxy --mode reverse:https://other_ip:27000@8080

# Examine indexes in discover

Dashboard -> Dashboard Management -> Dashboard Management -> Index patterns -> Create index pattern

Select is not a time series from the dropdown menu

# Check mappings

Dashboard -> Management -> Index management -> Indexes -> Select Index -> Tab Mappings

