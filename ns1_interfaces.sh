#!/bin/bash

# Criar subinterfaces sobre sim-veth1
ip link add link veth1 name wlan0 type macvlan mode bridge
ip link add link veth1 name cell0 type macvlan mode bridge

# Ativar interfaces
ip link set wlan0 up
ip link set cell0 up

# Atribuir IPs (um para rede Wi-Fi, outro para rede celular)
ip addr add 192.168.100.10/24 dev wlan0
ip addr add 10.0.100.10/24 dev cell0

# tabelas
echo "100 wifi"     | sudo tee -a /etc/iproute2/rt_tables
echo "200 celular"  | sudo tee -a /etc/iproute2/rt_tables

# rotas por tabela (corrigindo prefixos /24)
ip route add 192.168.100.0/24 dev wlan0 src 192.168.100.10 table wifi
ip route add default via 192.168.2.2 dev veth1 table wifi

ip route add 10.0.100.0/24 dev cell0 src 10.0.100.10 table celular
ip route add default via 192.168.2.2 dev veth1 table celular

# regras por origem
ip rule add from 192.168.100.10/32 table wifi
ip rule add from 10.0.100.10/32 table celular