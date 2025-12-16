# WireGuard VPN Server
# Description: High-performance modern VPN setup.

# 1. Interface
/interface wireguard
add listen-port=51820 mtu=1420 name=wireguard-server

# 2. IP Address
/ip address
add address=10.10.10.1/24 interface=wireguard-server network=10.10.10.0

# 3. Firewall Rules
/ip firewall filter
add action=accept chain=input dst-port=51820 protocol=udp comment="Allow WireGuard Handshake"
add action=accept chain=forward in-interface=wireguard-server comment="Allow VPN to LAN"
add action=accept chain=forward out-interface=wireguard-server comment="Allow LAN to VPN"

# 4. Peer Template (Copy this for each client)
# /interface wireguard peers
# add interface=wireguard-server public-key="CLIENT_PUBLIC_KEY_HERE" allowed-address=10.10.10.2/32 comment="Client-Phone"