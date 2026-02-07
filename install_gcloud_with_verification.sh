#!/bin/bash

# ==============================================================================
# Script de Instalación Automatizada de Google Cloud CLI
# Sistema Operativo: Linux Ubuntu 24.04.3 LTS
# Basado en: guia-instalacion-configuracion-cli-google.md y google-cli-console-config.pdf
# ==============================================================================

# Detener el script si ocurre algún error
set -e

# Colores para la salida
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}----------------------------------------------------------${NC}"
echo -e "${GREEN}Iniciando la instalación de Google Cloud CLI en Ubuntu...${NC}"
echo -e "${GREEN}----------------------------------------------------------${NC}"

# --- VALIDACIONES INICIALES ---

# 1. Comprobar privilegios de root/sudo
echo "[Validación] Comprobando permisos de superusuario..."
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Error: Este script debe ejecutarse con sudo.${NC}"
  echo "Ejemplo: sudo ./install_gcloud.sh"
  exit 1
fi

# 2. Comprobar conexión a internet
echo "[Validación] Comprobando conexión a internet..."
if ! curl -s --head  --request GET https://www.google.com | grep "200 OK" > /dev/null; then
  echo -e "${RED}Error: No se detectó conexión a internet o los servidores de Google no responden.${NC}"
  exit 1
fi

# 3. Comprobar espacio en disco (Requiere al menos 500MB libres)
echo "[Validación] Comprobando espacio en disco..."
FREE_SPACE=$(df / --output=avail -m | tail -1)
if [ "$FREE_SPACE" -lt 500 ]; then
  echo -e "${RED}Error: No hay suficiente espacio en disco (se requieren al menos 500MB).${NC}"
  exit 1
fi

# 4. Comprobar arquitectura del sistema
ARCH=$(uname -m)
if [[ "$ARCH" != "x86_64" && "$ARCH" != "aarch64" ]]; then
  echo -e "${RED}Advertencia: Arquitectura $ARCH no probada formalmente, pero se intentará continuar.${NC}"
fi

# --- PROCESO DE INSTALACIÓN ---

# Paso 1: Actualizar el Sistema e Instalar Dependencias
echo -e "\n${GREEN}[1/4] Actualizando índices e instalando dependencias (curl, gnupg)...${NC}"
apt-get update -qq
apt-get install -y apt-transport-https ca-certificates gnupg curl -qq

# Paso 2: Importar la Clave Pública de Google Cloud
echo -e "${GREEN}[2/4] Importando la clave GPG oficial de Google...${NC}"
# Limpiar claves antiguas para evitar conflictos de firmas
rm -f /usr/share/keyrings/cloud.google.gpg
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg

# Paso 3: Agregar el Repositorio de la CLI de gcloud
echo -e "${GREEN}[3/4] Registrando el repositorio oficial de Google Cloud...${NC}"
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list > /dev/null

# Paso 4: Instalar la CLI de gcloud
echo -e "${GREEN}[4/4] Instalando google-cloud-cli...${NC}"
apt-get update -qq
apt-get install -y google-cloud-cli -qq

# --- FINALIZACIÓN ---

echo -e "\n${GREEN}----------------------------------------------------------${NC}"
echo -e "${GREEN}¡Instalación completada con éxito!${NC}"
echo -e "Versión de gcloud instalada:"
gcloud --version | head -n 1
echo -e "${GREEN}----------------------------------------------------------${NC}"
echo "PRÓXIMOS PASOS SUGERIDOS:"
echo "1. Ejecuta 'gcloud init' para configurar tu cuenta y proyecto."
echo "2. Ejecuta 'gcloud auth login' si solo necesitas autenticarte."
echo -e "${GREEN}----------------------------------------------------------${NC}"
