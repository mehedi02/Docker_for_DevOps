#!/bin/bash
sudo ip netns add red
sudo ip netns add green

sudo ip link add br0 type bridge
sudo ip link set dev br0 up
sudo ip addr add 192.168.0.1/16 dev br0

sudo ip link add rveth type veth peer name rbveth
sudo ip link add gveth type veth peer name gbveth

sudo ip link set rveth netns red
sudo ip link set gveth netns green

sudo ip netns exec red ip link set dev lo up
sudo ip netns exec red ip link set dev rveth up
sudo ip netns exec green ip link set dev lo up
sudo ip netns exec green ip link set gveth up

sudo ip link set dev rbveth master br0
sudo ip link set dev gbveth master br0

sudo ip link set dev rbveth up
sudo ip link set dev gbveth up

sudo ip netns exec red ip addr add 192.168.0.2/24 dev rveth
sudo ip netns exec green ip addr add 192.168.0.3/24 dev gveth

sudo ip netns exec red ip route add default via 192.168.0.2 dev rveth
sudo ip netns exec green ip route add default via 192.168.0.3 dev gveth

