#!/bin/bash

# ==============================================================================
# Script: fix_upgrade_install.sh
# Objetivo: Corregir error de "component manager disabled" y actualizar GCP CLI
# Sistema: Linux Ubuntu 24.04.3 LTS
# ==============================================================================

# Detener si hay errores
set -e

# Colores para trazabilidad
INFO='\033[0;34m'
SUCCESS='\033[0;32m'
WARNING='\033[0;33m'
ERROR='\033[0;31m'
NC='\033[0m'

echo -e "${INFO}>>> Iniciando proceso de reparación y actualización de Google Cloud CLI...${NC}"

# --- 1. VALIDACIONES INICIALES ---

echo -e "${INFO}[1/6] Ejecutando validaciones de entorno...${NC}"

# Validar Sudo
if [ "$EUID" -ne 0 ]; then
  echo -e "${ERROR}Error: Este script debe ejecutarse con privilegios de superusuario (sudo).${NC}"
  echo "Uso: sudo ./fix_upgrade_install.sh"
  exit 1
fi

# Validar Conexión
if ! ping -c 1 google.com &> /dev/null; then
  echo -e "${ERROR}Error: No hay conexión a internet.${NC}"
  exit 1
fi

# Validar Versión de Ubuntu (Noble es 24.04)
OS_VER=$(lsb_release -cs)
echo -e "${SUCCESS}Entorno validado: Ubuntu $OS_VER detectado.${NC}"

# --- 2. LIMPIEZA DE CONFIGURACIONES PREVIAS Y LLAVES LEGACY ---

echo -e "${INFO}[2/6] Limpiando repositorios duplicados y llaves obsoletas...${NC}"

# Eliminar posibles archivos de lista duplicados para evitar conflictos
rm -f /etc/apt/sources.list.d/google-cloud-sdk.list
rm -f /etc/apt/sources.list.d/google-cloud-cli.list

# Corregir advertencia "Key stored in legacy trusted.gpg"
# Importar la llave de forma moderna en /usr/share/keyrings/
rm -f /usr/share/keyrings/cloud.google.gpg
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg

# --- 3. RE-CONFIGURACIÓN DEL REPOSITORIO OFICIAL ---

echo -e "${INFO}[3/6] Configurando repositorio oficial para Ubuntu 24.04...${NC}"

echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list > /dev/null

# --- 4. REINSTALACIÓN LIMPIA Y ACTUALIZACIÓN ---

echo -e "${INFO}[4/6] Ejecutando actualización y reinstalación de la CLI...${NC}"

apt-get update -qq

# Reinstalar para asegurar integridad de los binarios
apt-get install --reinstall -y google-cloud-cli -qq

# --- 5. INSTALACIÓN DE COMPONENTES ADICIONALES (SOLUCIÓN AL ERROR) ---

echo -e "${INFO}[5/6] Instalando componentes comunes (GKE auth, kubectl, etc.)...${NC}"
echo -e "${WARNING}Nota: En instalaciones APT, los componentes se instalan como paquetes individuales.${NC}"

# Instalamos los componentes más comunes que suelen dar error al ser "saltados" (skipped)
apt-get install -y \
    google-cloud-cli-gke-gcloud-auth-plugin \
    google-cloud-cli-app-engine-python \
    google-cloud-cli-app-engine-java \
    google-cloud-cli-pubsub-emulator \
    google-cloud-cli-firestore-emulator \
    kubectl -qq

# --- 6. VERIFICACIÓN FINAL ---

echo -e "${INFO}[6/6] Verificando estado de la instalación...${NC}"

echo -e "${SUCCESS}----------------------------------------------------------${NC}"
echo -e "${SUCCESS}Proceso finalizado correctamente.${NC}"
echo -e "${INFO}Versión actual:${NC}"
gcloud --version | head -n 1

echo -e "\n${INFO}Información de autenticación:${NC}"
gcloud auth list || echo -e "${WARNING}No hay cuentas autenticadas. Ejecuta 'gcloud init'.${NC}"

echo -e "${SUCCESS}----------------------------------------------------------${NC}"
echo -e "CONSEJO: A partir de ahora, para actualizar gcloud usa siempre:"
echo -e "${GREEN}sudo apt-get update && sudo apt-get install --only-upgrade google-cloud-cli${NC}"
echo -e "${SUCCESS}----------------------------------------------------------${NC}"