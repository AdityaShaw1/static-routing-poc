# 🔀 Static Routing POC Using Docker Containers

This project demonstrates a basic static routing setup between two simulated leaf switches (`leaf1` and `leaf2`) using Docker containers on Ubuntu.

It mimics SONiC-style static routing behavior without requiring a full SONiC image or CLI — perfect for learning and testing!

---

## 🧠 What It Does

- Creates two Ubuntu-based containers to act as "Leaf" switches
- Connects them using a virtual Ethernet (veth) link
- Assigns IP addresses and loopbacks
- Adds static routes so that each leaf can reach the other’s loopback
- Verifies connectivity using `ping`

---

## 🖥️ Topology

[Leaf1] [Leaf2]
lo: 192.168.1.1/32 lo: 192.168.2.1/32
| |
10.0.12.1/30 ———— veth ———— 10.0.12.2/30


---

## 🚀 How to Run It

### 1. Clone the Repo

```bash
git clone https://github.com/YOUR_USERNAME/static-routing-poc.git
cd static-routing-poc


chmod +x setup.sh
./setup.sh


✅ Test It

Try pinging the loopbacks:

docker exec -it leaf1 ping 192.168.2.1
docker exec -it leaf2 ping 192.168.1.1

📦 Requirements

    Ubuntu or Debian-based system

    Docker installed and running

    Basic understanding of Linux networking

📚 Learning Outcomes

    Understand how Linux containers can simulate routers/switches

    Learn how static routes work with ip route

    Discover how SONiC’s routing is built on Linux primitives


🔧 Cleanup

To remove containers and veth interfaces:

docker rm -f leaf1 leaf2
sudo ip link delete veth1

📌 Author

Your Name
GitHub: @AdityaShaw1

📜 License

MIT License — free to use, modify, and share.


