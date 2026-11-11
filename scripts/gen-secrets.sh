#!/bin/sh
# Generate the local secrets needed to build Bunch Linux.
# Existing files are never overwritten. Nothing here may ever be committed.
#
# Usage: scripts/gen-secrets.sh [secrets-dir]   (default: <repo>/secrets)
set -eu

DIR="${1:-$(cd "$(dirname "$0")/.." && pwd)/secrets}"
mkdir -p "$DIR"
chmod 700 "$DIR"
cd "$DIR"
umask 077

SUBJ="/O=Bunch Linux/OU=Bunch Linux Update"

# RAUC update CA: its certificate goes into the image as keyring.
if [ ! -f ca.key.pem ]; then
    echo "Generating RAUC CA..."
    openssl req -x509 -newkey rsa:4096 -nodes -sha256 -days 3650 \
        -keyout ca.key.pem -out ca.cert.pem \
        -subj "$SUBJ/CN=Bunch Linux Update CA" \
        -addext "basicConstraints=critical,CA:TRUE" \
        -addext "keyUsage=critical,keyCertSign,cRLSign"
fi

# RAUC signing certificate, issued by the CA above: signs the bundles.
if [ ! -f bunch-auth-update.key.pem ]; then
    echo "Generating RAUC bundle signing certificate..."
    openssl req -newkey rsa:4096 -nodes -sha256 \
        -keyout bunch-auth-update.key.pem -out bunch-auth-update.csr.pem \
        -subj "$SUBJ/CN=Bunch Linux Update Signing"
    printf 'basicConstraints=CA:FALSE\nkeyUsage=critical,digitalSignature\n' > signing.ext
    openssl x509 -req -sha256 -days 1825 \
        -in bunch-auth-update.csr.pem -CA ca.cert.pem -CAkey ca.key.pem \
        -CAcreateserial -extfile signing.ext -out bunch-auth-update.cert.pem
    rm -f signing.ext bunch-auth-update.csr.pem
fi

# WPA2 passphrase of the hotspot (BUNCH_WLAN_MODE = "ap").
if [ ! -f hotspot.psk ]; then
    echo "Generating hotspot passphrase..."
    openssl rand -hex 16 > hotspot.psk
fi

chmod 600 ./*.pem hotspot.psk

echo
echo "Secrets in $DIR:"
ls -1 "$DIR"
echo
[ -f wg0.conf ] || echo "NOTE: wg0.conf missing - WireGuard (hotspot uplink) will not be enabled."
[ -f wpa_supplicant-wlan0.conf ] || echo "NOTE: wpa_supplicant-wlan0.conf missing - needed only for BUNCH_WLAN_MODE = \"client\"."
echo "Hotspot passphrase: $(cat hotspot.psk)"
