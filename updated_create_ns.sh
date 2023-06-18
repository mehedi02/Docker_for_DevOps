#!/bin/bash

sudo ip netns add red
sudo ip netns add green

sudo ip link add br0 type bridge

sudo ip link add rveth type veth peer name rsveth
sudo ip link add gveth type veth peer name gsveth

sudo ip link set rveth netns red
sudo ip link set gveth netns green

sudo ip link set br0 up
sudo ip addr add 10.10.1.1/24 dev br0

sudo ip link set rsveth master br0
sudo ip link set gsveth master br0

sudo ip link set rsveth up
sudo ip link set gsveth up

sudo ip netns exec red ip link set dev lo up
sudo ip netns exec red ip link set dev rveth up
sudo ip netns exec red ip addr add 10.10.1.2/24 dev rveth
sudo ip netns exec red ip route add default via 10.10.1.1 dev rveth

sudo ip netns exec green ip link set dev lo up
sudo ip netns exec green ip link set dev gveth up
sudo ip netns exec green ip addr add 10.10.1.3/24 dev gveth
sudo ip netns exec green ip route add default via 10.10.1.1 dev gveth

# Enable IP forwarding
sudo sysctl -w net.ipv4.ip_forward=1

# Set up NAT rule
sudo iptables -t nat -A POSTROUTING -s 10.10.1.0/24 ! -o br0 -j MASQUERADE
