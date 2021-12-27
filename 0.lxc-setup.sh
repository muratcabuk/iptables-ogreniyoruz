#!/bin/bash
lxc storage create default dir

lxc profile create myprofile

lxc profile device add myprofile root disk path=/ pool=default

lxc profile show myprofile

lxc network create bridge172 --type=bridge ipv4.address="172.24.10.1/16" bridge.driver="native" ipv6.address=none ipv4.nat=false ipv4.dhcp=true
lxc network create bridge192 --type=bridge ipv4.address="192.168.10.1/24" bridge.driver="native" ipv6.address=none ipv4.nat=false ipv4.dhcp=true

lxc init ubuntu:21.04 c2 -p myprofile
lxc init ubuntu:21.04 client11 -p myprofile
lxc init ubuntu:21.04 client31 -p myprofile
lxc init ubuntu:21.04 firewall -p myprofile

lxc network attach bridge172 client11 eth0 
lxc network attach bridge172 client31 eth0 
lxc network attach bridge172 firewall eth0 

lxc network attach bridge192 firewall eth1 
lxc network attach bridge192 c2 eth0

lxc config device set client11 eth0 ipv4.address 172.24.10.11
lxc config device set client31 eth0 ipv4.address 172.24.10.31
lxc config device set firewall eth0 ipv4.address 172.24.10.10

lxc config device set firewall eth1 ipv4.address 192.168.10.10 
lxc config device set c2 eth0 ipv4.address 192.168.10.2

lxc config set client11 raw.lxc "lxc.net.0.ipv4.address = 172.24.10.11/16" 
lxc config set client31 raw.lxc "lxc.net.0.ipv4.address = 172.24.10.31/16" 
lxc config set c2 raw.lxc "lxc.net.0.ipv4.address = 192.168.10.2/24"

lxc config set client11 raw.lxc "lxc.net.0.ipv4.address = 172.24.10.11/16" 
lxc config set client31 raw.lxc "lxc.net.0.ipv4.address = 172.24.10.31/16" 
lxc config set c2 raw.lxc "lxc.net.0.ipv4.address = 192.168.10.2/24"

printf 'lxc.net.0.ipv4.address = 172.24.10.10/16\nlxc.net.1.ipv4.address = 192.168.10.10/24' | lxc config set firewall raw.lxc -

lxc start c2 client11 client31 firewall

lxc exec firewall -- ip a add 192.168.10.10/24 dev eth1



# firewall da default gateway olmamalı
lxc exec firewall -- ip route del default

#c2 için firewall bacağı olmalı
lxc exec c2 -- ip route del default
lxc exec c2 --  route add default gw 192.168.10.10 # veya ip route add default via 192.168.10.10 dev eth0

#client11 ve client31 için firewall bacağı olmalı
lxc exec client11 -- ip route del default
lxc exec client11 --  route add default gw 172.24.10.10 # veya ip route add default via 172.24.10.10  dev eth0

lxc exec client31 -- ip route del default
lxc exec client31 --  route add default gw 172.24.10.10 # veya ip route add default via 172.24.10.10  dev eth0



# # -------------------bütün servisleri  netcat ile oluşturuyoruz
# # -------------------------------- c2
# nohup sh -c  'while true ; do (echo -e "HTTP/1.1 200 OK\n\n" ; echo -e "\t$(date)\n") | sudo netcat -l -w 1 -p 80; done' &

# nohup sh -c  'while true ; do sudo  netcat -l -w 1 -p 22; done' &

# nohup sh -c  'while true ; do sudo  ns2 netcat -l -w 1 -p 21; done' &


# # -------------------------------- client11
# nohup sh -c  'while true ; do (echo -e "HTTP/1.1 200 OK\n\n" ; echo -e "\t$(date)\n") | sudo netcat -l -w 1 -p 80; done' &

# nohup sh -c  'while true ; do sudo  netcat -l -w 1 -p 22; done' &

# nohup sh -c  'while true ; do sudo netcat -l -w 1 -p 21; done' &

# # -------------------------------- client31
# nohup sh -c  'while true ; do (echo -e "HTTP/1.1 200 OK\n\n" ; echo -e "\t$(date)\n") | sudo  netcat -l -w 1 -p 80; done' &

# nohup sh -c  'while true ; do sudo netcat -l -w 1 -p 22; done' &

# nohup sh -c  'while true ; do sudo  netcat -l -w 1 -p 21; done' &

# # -------------------------------- firewall
# nohup sh -c  'while true ; do (echo -e "HTTP/1.1 200 OK\n\n" ; echo -e "\t$(date)\n") | sudo netcat -l -w 1 -p 80; done' &

# nohup sh -c  'while true ; do sudo  netcat -l -w 1 -p 22; done' &

# nohup sh -c  'while true ; do sudo  netcat -l -w 1 -p 21; done' &

# ```



