#!/bin/bash

# PING
# sudo ip netns exec ns1 ping 192.168.3.2

# IPERF 3 - DOWNLINK
sudo ip netns exec ns1 iperf3 -c 192.168.3.2 -i 1 -p 10021 -M 1400B -t 10
# sudo ip netns exec ns1 iperf3 -c 192.168.2.2 -i 1 -p 10021 -M 1400B -t 5

# VIDEO COM GUI
# sudo ip netns exec ns1 sudo -u joahannes env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY vlc --no-dbus --avcodec-hw=none --vout=opengl rtp://@:4004
# sudo ip netns exec ns1 sudo -u joahannes cvlc --no-dbus --aout=dummy --no-plugins-cache --no-audio --avcodec-hw=none rtp://@:4004
# sudo ip netns exec ns1 sudo -u joahannes cvlc --no-dbus --avcodec-hw=none rtp://@:4004

# # VIDEO SEM GUI
# sudo ip netns exec ns1 sudo -u joahannes cvlc --no-dbus --aout=dummy --no-plugins-cache --no-video --no-audio --avcodec-hw=none -vvv rtp://@:4004

# # kill child processes
# trap 'kill $(jobs -pr)' SIGINT SIGTERM EXIT