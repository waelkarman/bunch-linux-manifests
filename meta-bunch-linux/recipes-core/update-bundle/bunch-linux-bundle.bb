SUMMARY = "Bunch Linux RAUC update bundle"
LICENSE = "MIT"

inherit bundle bunch-secrets

RAUC_BUNDLE_DESCRIPTION = "Bunch Linux SYSTEM UPDATE"
RAUC_BUNDLE_COMPATIBLE = "bunch-linux"
RAUC_BUNDLE_VERSION = "${DISTRO_VERSION}"

RAUC_BUNDLE_FORMAT ?= "plain"
RAUC_BUNDLE_SLOTS ?= "rootfs"
RAUC_SLOT_rootfs ?= "${BUNCH_LINUX_IMAGE}"
RAUC_SLOT_rootfs[fstype] = "ext4"

# Signing key and certificate are never stored in the repository.
RAUC_CERT_NAME_PREFIX ?= "bunch-auth-update"
BUNCH_REQUIRED_SECRETS = "${RAUC_CERT_NAME_PREFIX}.key.pem ${RAUC_CERT_NAME_PREFIX}.cert.pem"
RAUC_KEY_FILE = "${BUNCH_SECRETS_DIR}/${RAUC_CERT_NAME_PREFIX}.key.pem"
RAUC_CERT_FILE = "${BUNCH_SECRETS_DIR}/${RAUC_CERT_NAME_PREFIX}.cert.pem"
