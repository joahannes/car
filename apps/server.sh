#!/bin/bash

# PING
# sudo ip netns exec ns2 ping 192.168.2.2

# IPERF 3 - DOWNLINK
sudo ip netns exec ns2 iperf3 -s -i 1 -p 10021
# sudo ip netns exec ns2 bash -c 'iperf3 -s -i 1 -p 10021 -J > /home/joahannes/server.json'

# VIDEO SEM GUI
# sudo ip netns exec ns2 sudo -u joahannes cvlc ocean.mkv -I dummy --no-dbus --aout=dummy --avcodec-hw=none --loop --sout '#transcode{vcodec=h264,acodec=mpga,vb=125k,ab=64k,deinterlace,scale=0.25,threads=2}:rtp{mux=ts,dst=192.168.2.2,port=4004}'

# # kill child processes
# trap 'kill $(jobs -pr)' SIGINT SIGTERM EXIT