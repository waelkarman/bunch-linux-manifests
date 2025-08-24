# Makefile per progetto Yocto con kas
# Converte lo script bash in target Make

# Configurazione
VENV_NAME := venv-kas
KAS_FILE := kas/bunch-linux-demo.yml
TARGET_IMAGE := bunch-linux-demo
MACHINE := raspberrypi4-64

# Colori per output
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m # No Color

# Target di default
.DEFAULT_GOAL := all

# Phony targets
.PHONY: help venv checkout build clean all distclean force-checkout build-only

# Help
help:
	@echo "$(GREEN)Makefile per progetto Yocto con kas$(NC)"
	@echo ""
	@echo "$(YELLOW)Target disponibili:$(NC)"
	@echo "  help           - Mostra questo help"
	@echo "  venv           - Setup ambiente virtuale Python con kas"
	@echo "  checkout       - Checkout dei sorgenti"
	@echo "  build          - Build del progetto"
	@echo "  clean          - Pulizia build (bitbake cleanall)"
	@echo "  all            - Checkout + build completo (default)"
	@echo "  distclean      - Pulizia completa (rimuove build/ e venv)"
	@echo "  force-checkout - Checkout forzato dei sorgenti"
	@echo "  build-only     - Solo build (senza checkout)"
	@echo ""
	@echo "$(YELLOW)Esempi:$(NC)"
	@echo "  make                    # Checkout + build completo"
	@echo "  make checkout           # Solo checkout"
	@echo "  make build-only         # Solo build"
	@echo "  make clean build        # Build pulito"

# Setup ambiente virtuale
$(VENV_NAME)/bin/activate:
	@echo "$(GREEN)[INFO] Creo ambiente virtuale: $(VENV_NAME)$(NC)"
	python3 -m venv $(VENV_NAME)
	@echo "$(GREEN)[INFO] Installo kas via pip$(NC)"
	$(VENV_NAME)/bin/pip install kas

venv: $(VENV_NAME)/bin/activate

# Verifica kas file
$(KAS_FILE):
	@if [ ! -f "$(KAS_FILE)" ]; then \
		echo "$(RED)[ERRORE] File non trovato: $(KAS_FILE)$(NC)"; \
		exit 1; \
	fi

# Checkout dei sorgenti
.checkout-done: $(VENV_NAME)/bin/activate $(KAS_FILE)
	@echo "$(GREEN)[INFO] === FASE CHECKOUT ===$(NC)"
	@echo "$(GREEN)[INFO] Checkout dei sorgenti...$(NC)"
	@. $(VENV_NAME)/bin/activate && kas checkout $(KAS_FILE)
	@echo "$(GREEN)[INFO] Checkout completato con successo$(NC)"
	@touch .checkout-done

checkout: .checkout-done

# Checkout forzato
force-checkout: $(VENV_NAME)/bin/activate $(KAS_FILE)
	@echo "$(GREEN)[INFO] === FASE CHECKOUT FORZATO ===$(NC)"
	@echo "$(YELLOW)[INFO] Checkout forzato dei sorgenti...$(NC)"
	@. $(VENV_NAME)/bin/activate && kas checkout --force-checkout $(KAS_FILE)
	@echo "$(GREEN)[INFO] Checkout forzato completato$(NC)"
	@touch .checkout-done

# Build del progetto
.build-done: .checkout-done
	@echo "$(GREEN)[INFO] === FASE BUILD ===$(NC)"
	@echo "$(GREEN)[INFO] Avvio build con file: $(KAS_FILE)$(NC)"
	@. $(VENV_NAME)/bin/activate && kas build $(KAS_FILE)
	@echo "$(GREEN)[INFO] Build completato con successo$(NC)"
	@touch .build-done

# Build senza checkout
build-only: $(VENV_NAME)/bin/activate $(KAS_FILE)
	@echo "$(GREEN)[INFO] === FASE BUILD (solo build) ===$(NC)"
	@echo "$(GREEN)[INFO] Avvio build con file: $(KAS_FILE)$(NC)"
	@. $(VENV_NAME)/bin/activate && kas build $(KAS_FILE)
	@echo "$(GREEN)[INFO] Build completato con successo$(NC)"
	@touch .build-done

build: .build-done

# Pulizia build
clean: $(VENV_NAME)/bin/activate $(KAS_FILE)
	@echo "$(YELLOW)[INFO] Pulizia del build precedente...$(NC)"
	@. $(VENV_NAME)/bin/activate && kas shell $(KAS_FILE) -c "bitbake -c cleanall $(TARGET_IMAGE)"
	@rm -f .build-done
	@echo "$(GREEN)[INFO] Pulizia completata$(NC)"

# Build pulito
clean-build: clean build

# Target principale: checkout + build
all: .build-done

# Pulizia completa
distclean:
	@echo "$(YELLOW)[INFO] Pulizia completa: rimuovo build/, venv e file temporanei$(NC)"
	rm -rf build/ $(VENV_NAME)/ .checkout-done .build-done
	@echo "$(GREEN)[INFO] Pulizia completa terminata$(NC)"

# Target per sviluppo kernel modules
module-dev: $(VENV_NAME)/bin/activate $(KAS_FILE)
	@echo "$(GREEN)[INFO] Setup per sviluppo moduli kernel$(NC)"
	@. $(VENV_NAME)/bin/activate && kas shell $(KAS_FILE) -c "devtool create-workspace"

# Deploy su target remoto (esempio)
deploy-target: .build-done
	@echo "$(GREEN)[INFO] Deploy su target remoto$(NC)"
	@if [ -z "$(TARGET_IP)" ]; then \
		echo "$(RED)[ERRORE] Specifica TARGET_IP=192.168.1.xxx$(NC)"; \
		exit 1; \
	fi
	@. $(VENV_NAME)/bin/activate && kas shell $(KAS_FILE) -c "devtool deploy-target $(TARGET_IMAGE) root@$(TARGET_IP)"

# Informazioni sul build
info:
	@echo "$(GREEN)Configurazione corrente:$(NC)"
	@echo "  KAS_FILE: $(KAS_FILE)"
	@echo "  TARGET_IMAGE: $(TARGET_IMAGE)"
	@echo "  MACHINE: $(MACHINE)"
	@echo "  VENV_NAME: $(VENV_NAME)"
	@echo ""
	@echo "$(GREEN)Status:$(NC)"
	@echo "  Ambiente virtuale: $(if [ -d $(VENV_NAME) ]; then echo 'Presente'; else echo 'Assente'; fi)"
	@echo "  Checkout fatto: $(if [ -f .checkout-done ]; then echo 'Sì'; else echo 'No'; fi)"
	@echo "  Build fatto: $(if [ -f .build-done ]; then echo 'Sì'; else echo 'No'; fi)"