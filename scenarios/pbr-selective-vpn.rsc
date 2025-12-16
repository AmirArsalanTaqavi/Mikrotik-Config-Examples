# Policy Based Routing (PBR) for VPN
# Description: Routes specific local IPs AND traffic to specific public IPs through a VPN tunnel.

# 1. Define Address Lists
# IPs of local devices that must use VPN
/ip firewall address-list
add list=FORCE_VPN_SOURCE address=192.168.1.50 comment="TV"
add list=FORCE_VPN_SOURCE address=192.168.1.51 comment="Console"

# Public IPs that must always be accessed via VPN (e.g., Spotify, Netflix, Restricted Work IP)
/ip firewall address-list
add list=FORCE_VPN_DEST address=142.250.0.0/16 comment="Google Services Example"
add list=FORCE_VPN_DEST address=8.8.8.8

# 2. Create Routing Table (RouterOS v7 Requirement)
/routing table add name=vpn-table fib

# 3. Mangle Rules (Mark Traffic)
/ip firewall mangle
# Rule A: Mark traffic coming FROM specific local devices
add action=mark-routing chain=prerouting src-address-list=FORCE_VPN_SOURCE \
    dst-address-type=!local new-routing-mark=vpn-table passthrough=yes comment="Route Source List via VPN"

# Rule B: Mark traffic going TO specific public IPs (regardless of who sent it)
add action=mark-routing chain=prerouting dst-address-list=FORCE_VPN_DEST \
    dst-address-type=!local new-routing-mark=vpn-table passthrough=yes comment="Route Dest List via VPN"

# 4. IP Route
# Replace 'wireguard-office' with your actual VPN interface name
/ip route
add dst-address=0.0.0.0/0 gateway=wireguard-office routing-table=vpn-table comment="Route marked traffic through VPN"

# 5. NAT (Masquerade)
# Ensure traffic leaving the VPN interface is NATed
/ip firewall nat
add action=masquerade chain=srcnat out-interface=wireguard-office