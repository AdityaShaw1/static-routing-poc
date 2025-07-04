#!/bin/bash

# Clean up old containers and interfaces
docker rm -f leaf1 leaf2 2>/dev/null
sudo ip link delete veth1 2>/dev/null

# Create two Ubuntu containers
docker run -dit --name leaf1 --privileged ubuntu bash
docker run -dit --name leaf2 --privileged ubuntu bash

# Install networking tools in both
docker exec -it leaf1 bash -c "apt update && apt install iproute2 iputils-ping -y"
docker exec -it leaf2 bash -c "apt update && apt install iproute2 iputils-ping -y"

# Create virtual Ethernet pair
sudo ip link add veth1 type veth peer name veth2

# Get container PIDs
PID1=$(docker inspect -f '{{.State.Pid}}' leaf1)
PID2=$(docker inspect -f '{{.State.Pid}}' leaf2)

# Attach veth to containers
sudo ip link set veth1 netns $PID1
sudo ip link set veth2 netns $PID2

# Configure leaf1
docker exec -it leaf1 bash -c "
ip link set veth1 up
ip addr add 10.0.12.1/30 dev veth1
ip addr add 192.168.1.1/32 dev lo
ip link set lo up
ip route add 192.168.2.1/32 via 10.0.12.2
"

# Configure leaf2
docker exec -it leaf2 bash -c "
ip link set veth2 up
ip addr add 10.0.12.2/30 dev veth2
ip addr add 192.168.2.1/32 dev lo
ip link set lo up
ip route add 192.168.1.1/32 via 10.0.12.1
"

echo "✅ Static routing lab setup complete. Try pinging:"
echo "docker exec -it leaf1 ping 192.168.2.1"
echo "docker exec -it leaf2 ping 192.168.1.1"
