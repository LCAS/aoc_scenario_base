#!/bin/bash
# enable routing in Kernel


echo -e "INTERNET SHARING IN CONTAINER NO LONGER NEEDED.\n  See https://github.com/jabasai/robot_host_configs on how to configure baremetal" >&2
exit 1


sudo sh -c echo 1 /proc/sys/net/ipv4/ip_forward

# wlp0... is the external network (wifi)
# enx... is the internal network talking to sensors
# IP for enx is 192.168.0.1@/24, no gateway!

interface_for_internent="enp89s0"
if [ "${ROBOT_PLATFORM}" == "dogtooth_platform" ]
then
   echo "Dependencies specific to ${ROBOT_PLATFORM}"
   interface_for_internent="enp89s0"
elif [ "${ROBOT_PLATFORM}" == "hunter_platform" ]
then
   echo "Dependencies specific to ${ROBOT_PLATFORM}"
   interface_for_internent="enp89s0"
   # enable kernel module: gs_usb
   # sudo modprobe gs_usb
   # bring up can interface
   sudo ip link set can0 up type can bitrate 500000
else
   echo "Provided robot platform does not exit ${ROBOT_PLATFORM}" 
   exit 1 
fi

# internet_iterface=`route | grep '^default' | grep -o '[^ ]*$'`
internet_iterface=`ip route get 8.8.8.8 | awk '{print $5}' | awk /./`
if [[ -z "$internet_iterface" ]]; then
   echo "Can not find a interface that has access to internet"
   exit 1
fi

echo "Found a interface that has access to internet ${internet_iterface}"
if [[ $# -eq 0 ]] ; then
    echo 'You need to provide interface to share the internet'
    echo "Setting for the default interface: $interface_for_internent"
else 
   interface_for_internent=$1
fi 

# setup NAT
sudo iptables -t nat -A POSTROUTING -o $internet_iterface -j MASQUERADE

# allow established connections from the outside world
sudo iptables -A FORWARD -i ${internet_iterface} -o ${interface_for_internent} -m state --state RELATED,ESTABLISHED -j ACCEPT

# allow internal network to talk to the outside world
sudo iptables -A FORWARD -i $interface_for_internent -o $internet_iterface -j ACCEPT

# https://autowarefoundation.github.io/autoware-documentation/main/support/troubleshooting/performance-troubleshooting/

if [ ! -e /tmp/multicast_is_set ]; then
   sudo ip link set lo multicast on
   touch /tmp/multicast_is_set
fi

sudo chmod -R 777  /home/ros/.cache

sudo sysctl -w net.core.rmem_max=2147483647
sudo sysctl -w net.ipv4.ipfrag_time=3
sudo sysctl -w net.ipv4.ipfrag_high_thresh=134217728
sudo sysctl -w net.core.rmem_default=2147483647

