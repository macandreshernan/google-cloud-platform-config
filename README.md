# google-cloud-platform-config
Archivos de configuracion

## Instalación CLI de Google Cloud Platform

Este repositorio contiene un script para configurar e instalar el CLI de Google Cloud Platform.

### Uso

Para ejecutar el script de instalación:

```bash
chmod +x cli-google-install.sh
./cli-google-install.sh
```

## Instalación con Verificación

Este script incluye validaciones adicionales (conexión a internet, espacio en disco, privilegios) antes de instalar el CLI.

### Uso

```bash
chmod +x install_gcloud_with_verification.sh
sudo ./install_gcloud_with_verification.sh
```

## Solución de Problemas y Actualización

Si encuentras errores como "component manager disabled" o necesitas actualizar la CLI de manera limpia, utiliza el script `fix_upgrade_install.sh`. Este script realiza:
- Validaciones de entorno.
- Limpieza de configuraciones antiguas.
- Re-configuración del repositorio oficial.
- Reinstalación limpia y actualización de componentes.

### Uso

```bash
chmod +x fix_upgrade_install.sh
sudo ./fix_upgrade_install.sh
```
