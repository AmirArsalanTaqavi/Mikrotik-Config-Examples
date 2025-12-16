# WireGuard Site-to-Site VPN Configuration
# Local Subnet: 192.168.10.0/24 | Remote Subnet: 192.168.20.0/24

# 1. Interface Setup
/interface wireguard
add listen-port=13231 name=wireguard1 comment="Site-to-Site Tunnel"

# 2. IP Address for Tunnel
/ip address
add address=10.0.0.1/30 interface=wireguard1

# 3. Peer Configuration (The Remote Office)
/interface wireguard peers
add allowed-address=10.0.0.2/32,192.168.20.0/24 endpoint-address=REMOTE_PUBLIC_IP \
    endpoint-port=13231 interface=wireguard1 public-key="REMOTE_PUBLIC_KEY"

# 4. Routing
/ip route
add dst-address=192.168.20.0/24 gateway=wireguard1 comment="Route to Remote Office"

# 5. Firewall
/ip firewall filter
add action=accept chain=input dst-port=13231 protocol=udp comment="Allow WireGuard Traffic"
add action=accept chain=forward in-interface=wireguard1 comment="Allow Traffic from Tunnel"