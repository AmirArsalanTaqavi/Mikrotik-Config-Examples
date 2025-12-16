# MikroTik RouterOS Configuration Scenarios

A collection of production-ready **MikroTik RouterOS** scripts designed for network administrators and DevOps engineers. These configurations cover essential scenarios ranging from initial provisioning to complex Multi-WAN setups and VPN tunneling.

## 📂 Repository Structure

### 1. Initial Provisioning

- **File:** `initial-provisioning.rsc`
- **Description:** A complete "God Script" for setting up a fresh router. It handles:
  - User creation & security hardening
  - Interface naming & bridging
  - IP addressing & DHCP Server setup
  - DNS & NAT (Masquerade)
  - Stateful Firewall rules (Input/Forward chains)

### 2. VPN & Tunneling (`scenarios/`)

- **`wireguard-server.rsc`**: Sets up the router as a high-performance WireGuard VPN server for remote clients.
- **`wireguard-site-to-site.rsc`**: Configures a secure tunnel between two office branches.
- **`l2tp-ipsec-vpn.rsc`**: Legacy VPN support for older clients (L2TP with IPsec PSK).

### 3. Network Engineering (`scenarios/`)

- **`multi-wan-pcc-load-balance.rsc`**: Implements **PCC (Per Connection Classifier)** to load balance traffic across two ISP lines for redundancy and speed aggregation.
- **`firewall-secure-default.rsc`**: A strict firewall ruleset protecting against port scanning, DDoS, and unauthorized access.

## ⚠️ Security Best Practices

Before deploying these scripts in a production environment (especially in Germany/EU compliant zones), ensure the following:

1.  **Change Default Credentials:** Disable the `admin` user immediately after creating a new superuser.
2.  **Disable Unused Services:** Turn off Telnet, FTP, and WWW (HTTP) under `/ip service`. Use SSH and WinBox only.
3.  **Sanitize Configs:** Never upload your Public IPs, Serial Numbers, or Passwords to public repositories.
4.  **Update RouterOS:** Ensure you are running the latest "Long-term" or "Stable" release.

## 🚀 Usage

To apply a script, upload the `.rsc` file to the router via WinBox or FTP, then execute:

```bash
/import file-name.rsc
```
