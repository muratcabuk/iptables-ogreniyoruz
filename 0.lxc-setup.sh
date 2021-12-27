#!/bin/bash
lxc storage create default dir

lxc profile create myprofile

lxc profile device add myprofile root disk path=/ pool=default

lxc profile show myprofile

lxc network create bridge172 --type=bridge ipv4.address="172.24.10.1/16" bridge.driver="native" ipv6.address=none ipv4.nat=false ipv4.dhcp=true
lxc network create bridge192 --type=bridge ipv4.address="192.168.10.1/24" bridge.driver="native" ipv6.address=none ipv4.nat=false ipv4.dhcp=true

lxc init ubuntu:21.04 sunucu2 -p myprofile
lxc init ubuntu:21.04 sunucu1 -p myprofile
lxc init ubuntu:21.04 sunucu3 -p myprofile
lxc init ubuntu:21.04 sunucufirewall -p myprofile

lxc network attach bridge172 sunucu1 eth0 
lxc network attach bridge172 sunucu3 eth0 
lxc network attach bridge172 sunucufirewall eth0 

lxc network attach bridge192 sunucufirewall eth1 
lxc network attach bridge192 sunucu2 eth0

lxc config device set sunucu1 eth0 ipv4.address 172.24.10.11
lxc config device set sunucu3 eth0 ipv4.address 172.24.10.31
lxc config device set sunucufirewall eth0 ipv4.address 172.24.10.10

lxc config device set sunucufirewall eth1 ipv4.address 192.168.10.10 
lxc config device set sunucu2 eth0 ipv4.address 192.168.10.2

lxc config set sunucu1 raw.lxc "lxc.net.0.ipv4.address = 172.24.10.11/16" 
lxc config set sunucu3 raw.lxc "lxc.net.0.ipv4.address = 172.24.10.31/16" 
lxc config set sunucu2 raw.lxc "lxc.net.0.ipv4.address = 192.168.10.2/24"

lxc config set sunucu1 raw.lxc "lxc.net.0.ipv4.address = 172.24.10.11/16" 
lxc config set sunucu3 raw.lxc "lxc.net.0.ipv4.address = 172.24.10.31/16" 
lxc config set sunucu2 raw.lxc "lxc.net.0.ipv4.address = 192.168.10.2/24"

printf 'lxc.net.0.ipv4.address = 172.24.10.10/16\nlxc.net.1.ipv4.address = 192.168.10.10/24' | lxc config set sunucufirewall raw.lxc -

lxc start sunucu2 sunucu1 sunucu3 sunucufirewall

lxc exec sunucufirewall -- ip a add 192.168.10.10/24 dev eth1



# sunucufirewall da default gateway olmamalı
lxc exec sunucufirewall -- ip route del default

#sunucu2 için sunucufirewall bacağı olmalı
lxc exec sunucu2 -- ip route del default
lxc exec sunucu2 --  route add default gw 192.168.10.10 # veya ip route add default via 192.168.10.10 dev eth0

#sunucu1 ve sunucu3 için sunucusunucufirewall bacağı olmalı
lxc exec sunucu1 -- ip route del default
lxc exec sunucu1 --  route add default gw 172.24.10.10 # veya ip route add default via 172.24.10.10  dev eth0

lxc exec sunucu3 -- ip route del default
lxc exec sunucu3 --  route add default gw 172.24.10.10 # veya ip route add default via 172.24.10.10  dev eth0



# # -------------------bütün servisleri  netcat ile oluşturuyoruz
# # -------------------------------- sunucu2
# nohup sh -c  'while true ; do (echo -e "HTTP/1.1 200 OK\n\n" ; echo -e "\t$(date)\n") | sudo netcat -l -w 1 -p 80; done' &

# nohup sh -c  'while true ; do sudo  netcat -l -w 1 -p 22; done' &

# nohup sh -c  'while true ; do sudo  ns2 netcat -l -w 1 -p 21; done' &


# # -------------------------------- sunucu1
# nohup sh -c  'while true ; do (echo -e "HTTP/1.1 200 OK\n\n" ; echo -e "\t$(date)\n") | sudo netcat -l -w 1 -p 80; done' &

# nohup sh -c  'while true ; do sudo  netcat -l -w 1 -p 22; done' &

# nohup sh -c  'while true ; do sudo netcat -l -w 1 -p 21; done' &

# # -------------------------------- sunucu3
# nohup sh -c  'while true ; do (echo -e "HTTP/1.1 200 OK\n\n" ; echo -e "\t$(date)\n") | sudo  netcat -l -w 1 -p 80; done' &

# nohup sh -c  'while true ; do sudo netcat -l -w 1 -p 22; done' &

# nohup sh -c  'while true ; do sudo  netcat -l -w 1 -p 21; done' &

# # -------------------------------- sunucufirewall
# nohup sh -c  'while true ; do (echo -e "HTTP/1.1 200 OK\n\n" ; echo -e "\t$(date)\n") | sudo netcat -l -w 1 -p 80; done' &

# nohup sh -c  'while true ; do sudo  netcat -l -w 1 -p 22; done' &

# nohup sh -c  'while true ; do sudo  netcat -l -w 1 -p 21; done' &

# ```



