# Multi-WAN Load Balancing using PCC (Per Connection Classifier)
# Scenario: 2 ISPs (ether1-ISP1, ether2-ISP2) and LAN (bridge-lan)

# 1. Mangle Rules (Marking Connections)
/ip firewall mangle
add action=mark-connection chain=prerouting dst-address-type=!local in-interface=bridge-lan \
    new-connection-mark=ISP1_conn passthrough=yes per-connection-classifier=both-addresses:2/0
add action=mark-connection chain=prerouting dst-address-type=!local in-interface=bridge-lan \
    new-connection-mark=ISP2_conn passthrough=yes per-connection-classifier=both-addresses:2/1

# 2. Mangle Rules (Marking Routing)
add action=mark-routing chain=prerouting connection-mark=ISP1_conn new-routing-mark=to_ISP1 passthrough=yes
add action=mark-routing chain=prerouting connection-mark=ISP2_conn new-routing-mark=to_ISP2 passthrough=yes

# 3. Routes
/ip route
add check-gateway=ping distance=1 gateway=1.1.1.1 routing-mark=to_ISP1 comment="Route via ISP1"
add check-gateway=ping distance=1 gateway=2.2.2.2 routing-mark=to_ISP2 comment="Route via ISP2"
add check-gateway=ping distance=1 gateway=1.1.1.1 comment="Default Route ISP1"
add check-gateway=ping distance=2 gateway=2.2.2.2 comment="Backup Route ISP2"

# 4. NAT
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1 comment="NAT ISP1"
add action=masquerade chain=srcnat out-interface=ether2 comment="NAT ISP2"