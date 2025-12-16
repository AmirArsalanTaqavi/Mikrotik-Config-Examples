# L2TP/IPsec VPN Server Setup
# Description: Enables L2TP server with IPsec encryption (Pre-Shared Key).

# 1. IP Pool for VPN Users
/ip pool add name=vpn-pool ranges=192.168.89.2-192.168.89.50

# 2. PPP Profile
/ppp profile
add name=vpn-profile local-address=192.168.89.1 remote-address=vpn-pool \
    dns-server=8.8.8.8 change-tcp-mss=yes

# 3. IPsec Proposal & Profile (Compatibility Mode)
/ip ipsec profile
add name=l2tp-profile dh-group=modp2048,modp1024 enc-algorithm=aes-256,aes-128,3des hash-algorithm=sha256,sha1
/ip ipsec proposal
add name=l2tp-proposal auth-algorithms=sha256,sha1 enc-algorithms=aes-256-cbc,aes-128-cbc,3des pfs-group=none

# 4. IPsec Peer & Identity
/ip ipsec peer
add name=l2tp-peer passive=yes profile=l2tp-profile exchange-mode=main-l2tp
/ip ipsec identity
add peer=l2tp-peer secret="YOUR_SECURE_PSK_HERE" generate-policy=port-strict

# 5. Enable L2TP Server
/interface l2tp-server server
set default-profile=vpn-profile enabled=yes use-ipsec=yes

# 6. Firewall Rules (Open Ports)
/ip firewall filter
add action=accept chain=input protocol=udp dst-port=500,4500,1701 comment="Allow L2TP/IPsec"
add action=accept chain=input protocol=ipsec-esp comment="Allow IPsec ESP"

# 7. Create User
/ppp secret
add name="vpnuser" password="userpassword" profile=vpn-profile service=l2tp