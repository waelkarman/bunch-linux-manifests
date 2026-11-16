# Bunch Linux build with kas.
#
#   make                 RPi: RAUC bundle + SD card image (same as `make build`)
#   make shell           RPi: bitbake shell in the build environment
#   make sdk             RPi: Qt6 cross-compilation SDK (build/tmp/deploy/sdk/*.sh)
#   make qemu            QEMU (qemuarm64): build the demo image
#   make qemu-run        QEMU: boot the image in the terminal (serial console)
#   make qemu-run-gui    QEMU: boot the image in an SDL window with virgl GL (Qt/GTK apps)
#                        add WEBCAM=vid:pid (from lsusb) to pass the host USB webcam to the guest
#   make qemu-ssh        QEMU: ssh into the running guest (root@localhost:2222)
#   make qemu-shell      QEMU: bitbake shell in the build environment
#   make help            list all targets
#
# Override variables on the command line, e.g.
#   make qemu-run QEMU_OPTS="nographic tap"

SHELL := /bin/bash
.DEFAULT_GOAL := build

VENV       := bunch-linux-env
KAS        := $(VENV)/bin/kas
RPI_KAS    := kas/bunch-linux-demo.yml
QEMU_KAS   := kas/qemu.yml
DEV_KAS    := kas/dev-repos.yml
SECRET_KEY := secrets/bunch-auth-update.key.pem
SDK_IMAGE  := bunch-linux-demo

QEMU_MACHINE  := qemuarm64
QEMU_OPTS     ?= nographic slirp
QEMU_GUI_OPTS ?= sdl gl slirp
QEMU_GPU      ?= -device virtio-gpu-pci
QEMU_GUI_GPU  ?= -device virtio-gpu-gl-pci
QEMU_IMAGE    := bunch-linux-demo
# Pass runqemu the qemuboot.conf instead of the MACHINE: its MACHINE check
# expects an image named *-image-* and logs a bogus DEPLOY_DIR_IMAGE error.
QEMU_CONF     := $(abspath build/tmp/deploy/images/$(QEMU_MACHINE)/$(QEMU_IMAGE)-$(QEMU_MACHINE).rootfs.qemuboot.conf)
SSH_PORT      ?= 2222
# Host USB webcam passed through to the guest (object-detector), as vid:pid from
# lsusb, e.g. make qemu-run-gui WEBCAM=3277:0060. Needs rw access to its
# /dev/bus/usb node: see `make webcam-udev`. The host loses the camera meanwhile.
WEBCAM        ?=
comma         := ,
WEBCAM_VID    := $(word 1,$(subst :, ,$(WEBCAM)))
WEBCAM_PID    := $(word 2,$(subst :, ,$(WEBCAM)))
QEMU_WEBCAM   := $(if $(WEBCAM),-device usb-host$(comma)vendorid=0x$(WEBCAM_VID)$(comma)productid=0x$(WEBCAM_PID))
# kas shell drops the user environment: hand the display back to QEMU/SDL
QEMU_DISPLAY_ENV := $(foreach v,DISPLAY WAYLAND_DISPLAY XDG_RUNTIME_DIR XAUTHORITY XDG_SESSION_TYPE,$(if $($(v)),$(v)='$($(v))'))

HOST_TOOLS := chrpath diffstat zstd lz4 file git

# kas spawns bitbake and friends: keep the venv first in PATH
export PATH := $(abspath $(VENV))/bin:$(PATH)

.PHONY: help deps kas-update checkout checkout-qemu checkout-dev \
        build shell sdk qemu qemu-run qemu-run-gui qemu-ssh qemu-shell webcam-udev

help: ## Show this help
	@grep -hE '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | \
		awk -F':.*## ' '{printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}'

# --- Host setup ---------------------------------------------------------------

deps: ## Install the host packages if missing (sudo apt)
	@missing=""; for t in $(HOST_TOOLS); do command -v $$t >/dev/null || missing="$$missing $$t"; done; \
	python3 -c 'import venv, ensurepip' 2>/dev/null || missing="$$missing python3-venv"; \
	if [ -n "$$missing" ]; then \
		echo "Missing host tools:$$missing"; \
		sudo apt update -y && \
		sudo apt install -y python3-venv python3-pip chrpath diffstat zstd git lz4 file; \
	fi

$(KAS): | deps
	python3 -m venv $(VENV)
	$(VENV)/bin/pip install --quiet --upgrade pip kas

kas-update: $(KAS) ## Upgrade kas in the venv
	$(VENV)/bin/pip install --quiet --upgrade pip kas

$(SECRET_KEY):
	@echo "No RAUC signing key found: generating local secrets (see secrets/README.md)"
	scripts/gen-secrets.sh

# --- Raspberry Pi ---------------------------------------------------------------

checkout: $(KAS) ## Check out the layers at the pinned commits (RPi)
	$(KAS) checkout $(RPI_KAS) --update --force-checkout

checkout-dev: $(KAS) ## Also check out the kernel fork and boot docs
	$(KAS) checkout $(RPI_KAS):$(DEV_KAS)

build: checkout $(SECRET_KEY) ## RPi: build the RAUC bundle and the SD card image
	$(KAS) build $(RPI_KAS)

shell: checkout $(SECRET_KEY) ## RPi: bitbake shell in the build environment
	$(KAS) shell $(RPI_KAS)

sdk: checkout $(SECRET_KEY) ## RPi: build the Qt6 SDK installer (build/tmp/deploy/sdk)
	$(KAS) build $(RPI_KAS) --target $(SDK_IMAGE) --task populate_sdk

# --- QEMU simulation ------------------------------------------------------------

checkout-qemu: $(KAS)
	$(KAS) checkout $(QEMU_KAS) --update --force-checkout

qemu: checkout-qemu $(SECRET_KEY) ## QEMU: build the demo image for qemuarm64
	$(KAS) build $(QEMU_KAS)

qemu-run: $(KAS) ## QEMU: boot the image on the serial console (Ctrl-a x to quit)
	$(KAS) shell $(QEMU_KAS) -c "bitbake qemu-helper-native && runqemu $(QEMU_CONF) $(QEMU_OPTS) qemuparams='$(QEMU_GPU) $(QEMU_WEBCAM)'"

qemu-run-gui: $(KAS) ## QEMU: boot the image in an SDL window
	$(KAS) shell $(QEMU_KAS) -c "bitbake qemu-helper-native && env $(QEMU_DISPLAY_ENV) runqemu $(QEMU_CONF) $(QEMU_GUI_OPTS) qemuparams='$(QEMU_GUI_GPU) $(QEMU_WEBCAM)'"

qemu-ssh: ## QEMU: ssh into the running guest
	ssh -p $(SSH_PORT) -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@localhost

qemu-shell: checkout-qemu $(SECRET_KEY) ## QEMU: bitbake shell in the build environment
	$(KAS) shell $(QEMU_KAS)

webcam-udev: ## QEMU: let the current user pass WEBCAM=vid:pid through (udev rule, sudo)
	@test -n "$(WEBCAM)" || { echo "Usage: make webcam-udev WEBCAM=vid:pid (see lsusb)"; exit 1; }
	echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="$(WEBCAM_VID)", ATTR{idProduct}=="$(WEBCAM_PID)", MODE="0660", TAG+="uaccess"' | \
		sudo tee /etc/udev/rules.d/70-bunch-linux-webcam.rules
	sudo udevadm control --reload-rules && sudo udevadm trigger --subsystem-match=usb
