# system.conf comes from this layer, the keyring (CA certificate) from the
# local secrets directory: see secrets/README.md.
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

inherit bunch-secrets
BUNCH_REQUIRED_SECRETS = "${RAUC_KEYRING_FILE}"

RDEPENDS:${PN} += "mmc-utils"
