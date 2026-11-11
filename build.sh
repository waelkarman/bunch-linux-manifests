#!/bin/bash
# Build Bunch Linux with kas.
#   ./build.sh          build the default target (RAUC bundle + image)
#   ./build.sh shell    open a bitbake shell in the build environment
set -e

cd "$(dirname "$0")"
VENV_DIR="bunch-linux-env"
KAS_FILE="kas/bunch-linux-demo.yml"

if ! command -v chrpath >/dev/null || ! command -v diffstat >/dev/null || ! command -v zstd >/dev/null; then
    sudo apt update -y
    sudo apt install -y python3-venv python3-pip chrpath diffstat zstd git lz4 file
fi

if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
fi
source "$VENV_DIR/bin/activate"
pip install --quiet --upgrade pip kas

if [ ! -f secrets/bunch-auth-update.key.pem ]; then
    echo "No RAUC signing key found: generating local secrets (see secrets/README.md)"
    scripts/gen-secrets.sh
fi

kas checkout "$KAS_FILE" --update --force-checkout

case "${1:-build}" in
    shell) kas shell "$KAS_FILE" ;;
    build) kas build "$KAS_FILE" ;;
    *) echo "usage: $0 [build|shell]"; exit 1 ;;
esac
