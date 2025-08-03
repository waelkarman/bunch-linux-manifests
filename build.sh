#!/bin/bash
# Nome dell'ambiente virtuale
VENV_NAME="venv-kas"
# Percorso del file kas.yml 
KAS_FILE="kas/bunch-linux-demo.yml"

# Parametri da linea di comando
CLEAN_BUILD=false
FORCE_CHECKOUT=false

# Parsing degli argomenti
while [[ $# -gt 0 ]]; do
    case $1 in
        --clean)
            CLEAN_BUILD=true
            shift
            ;;
        --force-checkout)
            FORCE_CHECKOUT=true
            shift
            ;;
        *)
            echo "Uso: $0 [--clean] [--force-checkout]"
            exit 1
            ;;
    esac
done

# Crea l'ambiente virtuale se non esiste
if [ ! -d "$VENV_NAME" ]; then
    echo "[INFO] Creo ambiente virtuale: $VENV_NAME"
    python3 -m venv "$VENV_NAME"
fi

# Attiva l'ambiente virtuale
echo "[INFO] Attivo ambiente virtuale"
source "$VENV_NAME/bin/activate"

# Installa kas se non è già presente
if ! command -v kas &> /dev/null; then
    echo "[INFO] Installo kas via pip"
    pip install kas
else
    echo "[INFO] kas è già installato"
fi

# Lancia il build
if [ -f "$KAS_FILE" ]; then
    echo "[INFO] Avvio kas build con file: $KAS_FILE"
    
    # Pulizia condizionale
    if [ "$CLEAN_BUILD" = true ]; then
        echo "[INFO] Pulizia del build precedente..."
        kas shell "$KAS_FILE" -c "bitbake -c cleanall bunch-linux-demo"
    fi
    
    # Build con o senza force-checkout
    if [ "$FORCE_CHECKOUT" = true ]; then
        kas build --force-checkout "$KAS_FILE"
    else
        kas build "$KAS_FILE"
    fi
else
    echo "[ERRORE] File non trovato: $KAS_FILE"
    deactivate
    exit 1
fi

# Disattiva ambiente virtuale
deactivate
echo "[INFO] Build completata e ambiente virtuale disattivato"