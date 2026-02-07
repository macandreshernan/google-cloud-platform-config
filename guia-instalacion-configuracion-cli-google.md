# Paso 1: Actualizar el Sistema e Instalar Dependencias
# Actualizar los índices de paquetes
sudo apt-get update

# Instalar dependencias necesarias
sudo apt-get install -y apt-transport-https ca-certificates gnupg curl

# Paso 2: Importar la Clave Pública de Google Cloud
# Importar la clave pública y guardarla en el anillo de claves del sistema
curl [https://packages.cloud.google.com/apt/doc/apt-key.gpg](https://packages.cloud.google.com/apt/doc/apt-key.gpg) | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg

# Paso 3: Agregar el Repositorio de la CLI de gcloud
# Actualizar e instalar la CLI
sudo apt-get update && sudo apt-get install -y google-cloud-cli

# Comando utiles posterior a la instalacion
## gcloud --version	Verifica la versión instalada.
## gcloud auth list	Muestra las cuentas activas.
## gcloud config list	Muestra el proyecto y región configurados.
## gcloud components update	Actualiza el SDK a la última versión.(NO FUNCIONA)
## Sudo apt-get update && sudo apt-get install --only-upgrade google-cloud-cli

# Upgrade: upgrade components
## sudo apt-get update && sudo apt-get --only-upgrade install google-cloud-cli-app-engine-java google-cloud-cli-app-engine-go google-cloud-cli-app-engine-grpc google-cloud-cli-enterprise-certificate-proxy google-cloud-cli-gke-gcloud-auth-plugin google-cloud-cli-spanner-migration-tool google-cloud-cli-minikube google-cloud-cli-spanner-emulator google-cloud-cli-datastore-emulator google-cloud-cli-firestore-emulator google-cloud-cli-log-streaming google-cloud-cli-anthos-auth google-cloud-cli-cbt google-cloud-cli-spanner-cli google-cloud-cli-config-connector google-cloud-cli-managed-flink-client kubectl google-cloud-cli-nomos google-cloud-cli google-cloud-cli-app-engine-python google-cloud-cli-terraform-tools google-cloud-cli-cloud-build-local google-cloud-cli-kubectl-oidc google-cloud-cli-skaffold google-cloud-cli-package-go-module google-cloud-cli-cloud-run-proxy google-cloud-cli-anthoscli google-cloud-cli-kpt google-cloud-cli-bigtable-emulator google-cloud-cli-app-engine-python-extras google-cloud-cli-istioctl google-cloud-cli-docker-credential-gcr google-cloud-cli-pubsub-emulator google-cloud-cli-local-extract google-cloud-cli-run-compose

