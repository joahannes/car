#!/bin/bash
#   
#   
#   +++++++++++++++++++++++++     +++++++++++++++++++++++++     +++++++++++++++++++++++++
#   +     Namespace ns1     +     +         Simu5G        +     +     Namespace ns2     +
#   +                       +     +                       +     +                       +
#   +  Client App     [veth1]<--->[sim-veth1]   [sim-veth2]<--->[veth2]     Server App  +
#   +            192.168.2.2+     +                       +     +192.168.3.2            +
#   +                       +     +                       +     +                       +
#   +++++++++++++++++++++++++     +++++++++++++++++++++++++     +++++++++++++++++++++++++
#   

# create two namespaces
sudo ip netns add ns1
sudo ip netns add ns2

# create virtual ethernet link: ns1.veth1 <--> sim-veth1 , sim-veth2 <--> ns2.veth2 
sudo ip link add veth1 netns ns1 type veth peer name sim-veth1
sudo ip link add veth2 netns ns2 type veth peer name sim-veth2

# Assign the address 192.168.2.2 with netmask 255.255.255.0 to `veth1`
sudo ip netns exec ns1 ip addr add 192.168.2.2/24 dev veth1
 
# Assign the address 192.168.3.2 with netmask 255.255.255.0 to `veth2`
sudo ip netns exec ns2 ip addr add 192.168.3.2/24 dev veth2

# bring up all interfaces
sudo ip netns exec ns1 ip link set veth1 up
sudo ip netns exec ns2 ip link set veth2 up

sudo ip link set sim-veth1 up
sudo ip link set sim-veth2 up

# add default IP route within new namespaces 
sudo ip netns exec ns1 route add default dev veth1
sudo ip netns exec ns2 route add default dev veth2

# disable TCP checksum offloading to make sure that TCP checksum is actually calculated
sudo ip netns exec ns1 ethtool --offload veth1 rx off tx off 
sudo ip netns exec ns2 ethtool --offload veth2 rx off tx off 

# +-------------------+           +--------------------+           +-------------------+
# |     Namespace     |           |      Simu5G        |           |     Namespace     |
# |       ns1         |           | (sua simulação)    |           |       ns2         |
# |                   |           |                    |           |                   |
# | veth-wifi <------>| sim-veth-wifi   (car.eth[0])   |<--------->| veth-ext          |
# | 192.168.0.2/24    |           |                    |           | 192.168.3.2/24    |
# |                   |           |                    |           |                   |
# | veth-5g  <------->| sim-veth-5g     (car.eth[1])   |           |                   |
# | 10.0.0.2/24       |           |                    |           |                   |
# +-------------------+           +--------------------+           +-------------------+

#!/bin/bash
# set -e

# # --- nomes das portas no host (lado "sim") ---
# SIM_WIFI=sim-veth-wifi
# SIM_5G=sim-veth-5g
# SIM_EXT=sim-veth-ext       # lado do servidor (ns2)

# # --- namespaces ---
# NS1=ns1
# NS2=ns2

# # --- nomes das portas dentro dos namespaces ---
# NS1_WIFI=veth-wifi
# NS1_5G=veth-5g
# NS2_EXT=veth-ext

# # --- endereços ---
# NS1_WIFI_IP=192.168.0.2/24   # Wi-Fi (ns1)
# NS1_5G_IP=10.0.0.2/24        # 5G (ns1)
# NS2_EXT_IP=192.168.3.2/24    # Server (ns2)

# # ============ limpeza opcional ============
# cleanup() {
#   ip netns del "$NS1" 2>/dev/null || true
#   ip netns del "$NS2" 2>/dev/null || true
#   ip link del "$SIM_WIFI" 2>/dev/null || true
#   ip link del "$SIM_5G" 2>/dev/null || true
#   ip link del "$SIM_EXT" 2>/dev/null || true
# }
# cleanup

# # ============ namespaces ============
# ip netns add "$NS1"
# ip netns add "$NS2"
# ip netns exec "$NS1" ip link set lo up
# ip netns exec "$NS2" ip link set lo up

# # ============ pares veth ============
# ip link add "$NS1_WIFI" netns "$NS1" type veth peer name "$SIM_WIFI"
# ip link add "$NS1_5G"   netns "$NS1" type veth peer name "$SIM_5G"
# ip link add "$NS2_EXT"  netns "$NS2" type veth peer name "$SIM_EXT"

# # ============ IPs ============
# ip netns exec "$NS1" ip addr add "$NS1_WIFI_IP" dev "$NS1_WIFI"
# ip netns exec "$NS1" ip addr add "$NS1_5G_IP"   dev "$NS1_5G"
# ip netns exec "$NS2" ip addr add "$NS2_EXT_IP"  dev "$NS2_EXT"

# # ============ subir ============
# ip netns exec "$NS1" ip link set "$NS1_WIFI" up
# ip netns exec "$NS1" ip link set "$NS1_5G" up
# ip netns exec "$NS2" ip link set "$NS2_EXT" up

# ip link set "$SIM_WIFI" up
# ip link set "$SIM_5G" up
# ip link set "$SIM_EXT" up

# # ============ MTU / offload ============
# for IF in $SIM_WIFI $SIM_5G $SIM_EXT; do
#   ip link set "$IF" mtu 4470
#   ethtool --offload "$IF" rx off tx off || true
# done

# ip netns exec "$NS1" ip link set "$NS1_WIFI" mtu 4470
# ip netns exec "$NS1" ip link set "$NS1_5G"  mtu 4470
# ip netns exec "$NS2" ip link set "$NS2_EXT" mtu 4470

# # ============ rotas ============
# # ns1: default via 5G
# ip netns exec "$NS1" ip route add default dev "$NS1_5G"
# # ns2: default pela única interface
# ip netns exec "$NS2" ip route add default dev "$NS2_EXT"

# echo "✅ ns1 pronto com duas interfaces:"
# echo "   Wi-Fi -> $NS1_WIFI ($NS1_WIFI_IP) <-> $SIM_WIFI"
# echo "   5G    -> $NS1_5G  ($NS1_5G_IP) <-> $SIM_5G"
# echo "✅ ns2 pronto com $NS2_EXT ($NS2_EXT_IP) <-> $SIM_EXT"
