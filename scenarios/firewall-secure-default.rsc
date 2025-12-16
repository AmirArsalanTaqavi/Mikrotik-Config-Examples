# MikroTik Secure Firewall Template (RouterOS v7)
# Description: Hardens Input (Router protection) and Forward (LAN protection) chains.
# Note: Ensure you define your WAN interface list before applying.

# 0. Define Interface Lists
/interface list add name=WAN
/interface list add name=LAN
# Adjust 'ether1' to your actual WAN port
/interface list member add interface=ether1 list=WAN 
/interface list member add interface=bridge-lan list=LAN

# 1. Connection Tracking (Performance)
/ip firewall raw
add action=notrack chain=prerouting src-address-list=bad_ips comment="Drop bad IPs early"

# 2. Input Chain (Protecting the Router)
/ip firewall filter
add action=accept chain=input connection-state=established,related,untracked comment="Accept Established/Related"
add action=drop chain=input connection-state=invalid comment="Drop Invalid"
add action=accept chain=input protocol=icmp comment="Allow Ping"
add action=accept chain=input dst-address=127.0.0.1 comment="Allow Localhost"
add action=accept chain=input src-address-list=allowed_admins comment="Allow Management from Trusted IPs"
add action=accept chain=input in-interface-list=LAN comment="Allow All LAN Input"
add action=drop chain=input comment="Drop Everything Else (WAN Input)"

# 3. Forward Chain (Protecting the LAN)
/ip firewall filter
add action=fasttrack-connection chain=forward connection-state=established,related comment="FastTrack"
add action=accept chain=forward connection-state=established,related,untracked comment="Accept Established/Related"
add action=drop chain=forward connection-state=invalid comment="Drop Invalid"
add action=drop chain=forward connection-nat-state=!dstnat connection-state=new in-interface-list=WAN comment="Drop incoming from WAN not DSTNATed"