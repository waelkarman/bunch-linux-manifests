#!/bin/bash
set -e

VENV_DIR="bunch-linux-env"

sudo apt update -y
sudo apt install -y python3-venv python3-pip chrpath diffstat zstd git

if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
fi

source "$VENV_DIR/bin/activate"

pip install --upgrade pip
pip install kas

kas checkout kas/bunch-linux-demo.yml --update --force-checkout
kas shell kas/bunch-linux-demo.yml
