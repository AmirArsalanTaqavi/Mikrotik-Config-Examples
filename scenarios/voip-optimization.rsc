# MikroTik VoIP Optimization & TFTP Config

# --- Variables ---
# change these for your network
:local issabelIP "192.168.88.200"
:local lanNetwork "192.168.88.0/24"

# 1. DHCP Option 150 (Cisco TFTP)
# Note: Value format requires strict string quoting for IPs
/ip dhcp-server option
add code=150 name="cisco-tftp-150" value=("'" . $issabelIP . "'")

# Assign to Network (Update the address-pool or network lookup as needed)
/ip dhcp-server network
set [find address=$lanNetwork] dhcp-option=cisco-tftp-150

# 2. Disable SIP ALG (Prevents One-Way Audio issues)
/ip firewall service-port
set sip disabled=yes ports=5060,5061
set h323 disabled=yes

# 3. Connection Tracking Optimization (Prevents Registration Drops)
/ip firewall connection tracking
set udp-timeout=20s udp-stream-timeout=3m

# 4. Simple QoS (Prioritize PBX Traffic)
/queue simple
add name="VoIP-Priority" target=$issabelIP priority=1/1 max-limit=100M/100M comment="Prioritize Issabel Traffic"
