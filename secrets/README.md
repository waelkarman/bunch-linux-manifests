# Local secrets

Everything in this directory except this README is git-ignored. Never commit it.
The build reads it through `BUNCH_SECRETS_DIR` (default: this directory).

Run `scripts/gen-secrets.sh` to create what can be generated.

| File | Needed for | How to get it |
|---|---|---|
| `ca.cert.pem`, `ca.key.pem` | RAUC keyring in the image (cert) and CA | `gen-secrets.sh` |
| `bunch-auth-update.cert.pem`, `bunch-auth-update.key.pem` | Signing the RAUC bundles | `gen-secrets.sh` |
| `hotspot.psk` | Hotspot passphrase (`BUNCH_WLAN_MODE = "ap"`) | `gen-secrets.sh`, or write your own (8–63 chars, one line) |
| `wg0.conf` | WireGuard uplink of the hotspot (optional) | Your VPN provider / server |
| `wpa_supplicant-wlan0.conf` | Wi-Fi client (`BUNCH_WLAN_MODE = "client"`) | See the example below |

`wpa_supplicant-wlan0.conf` example:

```
ctrl_interface=/var/run/wpa_supplicant
update_config=1
country=IT

network={
    ssid="MyNetwork"
    psk="MyPassword"
}
```

Keep a backup of the CA key somewhere safe: devices only accept bundles signed
by a certificate issued by the CA whose certificate is in their image.

`old-compromised/` holds the keys that were published in the git history.
They must be considered public. Their only remaining use is to sign one last
bundle that moves devices still in the field onto the new CA.
