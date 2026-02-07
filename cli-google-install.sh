#!/bin/bash

# ==============================================================================
# Script de Instalación Automatizada de Google Cloud CLI
# Sistema Operativo: Linux Ubuntu 24.04.3 LTS
# Basado en: guia-instalacion-configuracion-cli-google.md y google-cli-console-config.pdf
# ==============================================================================

# Detener el script si ocurre algún error
set -e

echo "----------------------------------------------------------"
echo "Iniciando la instalación de Google Cloud CLI en Ubuntu..."
echo "----------------------------------------------------------"

# Paso 1: Actualizar el Sistema e Instalar Dependencias
echo "[1/4] Actualizando índices de paquetes e instalando dependencias..."
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates gnupg curl

# Paso 2: Importar la Clave Pública de Google Cloud
echo "[2/4] Importando la clave GPG oficial de Google..."
# Se asegura de limpiar versiones previas de la clave si existen
sudo rm -f /usr/share/keyrings/cloud.google.gpg
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg

# Paso 3: Agregar el Repositorio de la CLI de gcloud
echo "[3/4] Registrando el repositorio oficial de Google Cloud..."
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list

# Paso 4: Instalar la CLI de gcloud
echo "[4/4] Realizando la instalación final de google-cloud-cli..."
sudo apt-get update && sudo apt-get install -y google-cloud-cli

echo "----------------------------------------------------------"
echo "¡Instalación exitosa!"
echo "Versión instalada:"
gcloud --version
echo "----------------------------------------------------------"
echo "SIGUIENTE PASO: Ejecuta 'gcloud init' para configurar tu cuenta."
echo "----------------------------------------------------------"
