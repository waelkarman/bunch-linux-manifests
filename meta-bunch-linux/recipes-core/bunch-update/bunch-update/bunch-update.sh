#!/bin/sh
# Bunch Linux auto-update: installs a RAUC bundle when the published version
# is newer than the running one. The bundle signature is verified by RAUC
# against the keyring in /etc/rauc.

BUNCH_SERVER="${BUNCH_SERVER:-https://waelkarman.github.io/bunch-linux-manifests}"
MANIFEST=/tmp/bunch-update.json
BUNDLE=/home/root/update.raucb

cleanup() { rm -f "$MANIFEST" "$BUNDLE"; }
trap cleanup EXIT

# version_gt A B: true if version A is newer than B.
# Versions are numbers separated by '.' or '-', e.g. 1.0.0 or 0.0.2-00002.
version_gt() {
	awk -v a="$1" -v b="$2" 'BEGIN {
		n = split(a, x, /[.-]/); m = split(b, y, /[.-]/)
		k = (n > m) ? n : m
		for (i = 1; i <= k; i++) {
			if ((x[i] + 0) > (y[i] + 0)) exit 0
			if ((x[i] + 0) < (y[i] + 0)) exit 1
		}
		exit 1
	}'
}

if ! curl --connect-timeout 5 --silent --fail --location --output "$MANIFEST" "$BUNCH_SERVER/bunch-update.json"; then
	echo "Failed to download $BUNCH_SERVER/bunch-update.json"
	exit 0
fi

CURRENT=$(. /etc/os-release && echo "$VERSION_ID")
AVAILABLE=$(jq -r '.version // empty' "$MANIFEST")
URL=$(jq -r '.url // empty' "$MANIFEST")

if [ -z "$AVAILABLE" ] || [ -z "$URL" ]; then
	echo "Invalid update manifest"
	exit 1
fi
case "$URL" in
	https://*) ;;
	*) echo "Refusing non-HTTPS bundle URL: $URL"; exit 1 ;;
esac

if ! version_gt "$AVAILABLE" "$CURRENT"; then
	echo "System up to date ($CURRENT, available $AVAILABLE)."
	exit 0
fi

echo "Update $CURRENT -> $AVAILABLE: downloading $URL"
if ! curl --connect-timeout 10 --silent --show-error --fail --location --output "$BUNDLE" "$URL"; then
	echo "Failed to download $URL"
	exit 1
fi

if rauc install "$BUNDLE"; then
	echo "System updated to $AVAILABLE, rebooting"
	rm -f "$BUNDLE"
	systemctl reboot
else
	echo "Update failed"
	exit 1
fi
