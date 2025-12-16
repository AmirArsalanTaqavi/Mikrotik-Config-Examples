# Whitelist Internet Access (No Error Icon)
# Description: Blocks internet for unauthorized IPs, but allows connectivity checks
# to prevent the "No Internet Access" warning on OS/Mobile devices.

# 1. Define Address Lists
# List of IPs ALLOWED to have full internet
/ip firewall address-list
add list=INTERNET_ALLOWED address=192.168.1.10 comment="Admin PC"
add list=INTERNET_ALLOWED address=192.168.1.20 comment="Boss Phone"

# List of domains used for Connectivity Checks (OS Validation)
# RouterOS v7 automatically resolves these domains to IPs dynamically
/ip firewall address-list
add list=CONNECTIVITY_CHECK address=dns.google
add list=CONNECTIVITY_CHECK address=clients3.google.com
add list=CONNECTIVITY_CHECK address=connectivitycheck.gstatic.com
add list=CONNECTIVITY_CHECK address=msftconnecttest.com
add list=CONNECTIVITY_CHECK address=www.msftconnecttest.com
add list=CONNECTIVITY_CHECK address=captive.apple.com
add list=CONNECTIVITY_CHECK address=www.apple.com

# 2. Firewall Filter Rules (Forward Chain)
# Place these rules near the top of your Forward chain

# A. Allow DNS for everyone (Required for connectivity checks to resolve)
/ip firewall filter
add action=accept chain=forward dst-port=53 protocol=udp comment="Allow DNS for All"
add action=accept chain=forward dst-port=53 protocol=tcp comment="Allow DNS for All"

# B. Allow Connectivity Checks for everyone (Prevents the Error Icon)
add action=accept chain=forward dst-address-list=CONNECTIVITY_CHECK protocol=tcp dst-port=80,443 comment="Allow OS Connectivity Checks"

# C. Allow Full Internet ONLY for Whitelisted IPs
add action=accept chain=forward src-address-list=INTERNET_ALLOWED comment="Allow Internet for Whitelist"

# D. Drop everything else (Blocks internet for non-whitelisted IPs)
add action=drop chain=forward in-interface-list=LAN out-interface-list=WAN comment="Block Internet for non-whitelist"