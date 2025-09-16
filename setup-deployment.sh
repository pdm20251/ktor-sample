#!/bin/bash

# Script para configurar o deployment no Google Cloud

set -e

# Variáveis (substitua pelos seus valores)
PROJECT_ID="estudapp-71947"
REGION="us-central1"
REPO_NAME="ktor-sample"
GITHUB_OWNER="pdm20251"
GITHUB_REPO="ktor-sample"
BRANCH_NAME="main"

echo "🚀 Configurando deployment para o projeto: $PROJECT_ID"

# 1. Habilitar APIs necessárias
echo "📡 Habilitando APIs do Google Cloud..."
gcloud services enable cloudbuild.googleapis.com \
  containerregistry.googleapis.com \
  run.googleapis.com \
  --project=$PROJECT_ID

# 2. Configurar permissões do Cloud Build
echo "🔑 Configurando permissões do Cloud Build..."
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")
CLOUD_BUILD_SA="${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:${CLOUD_BUILD_SA}" \
  --role="roles/run.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:${CLOUD_BUILD_SA}" \
  --role="roles/iam.serviceAccountUser"

# 3. Conectar repositório GitHub (requer configuração manual no Console)
echo "🔗 Para conectar o GitHub, acesse:"
echo "https://console.cloud.google.com/cloud-build/triggers?project=${PROJECT_ID}"
echo ""
echo "Ou execute o comando abaixo se já tiver o GitHub conectado:"
echo ""
echo "gcloud builds triggers create github \\"
echo "  --repo-name=${GITHUB_REPO} \\"
echo "  --repo-owner=${GITHUB_OWNER} \\"
echo "  --branch-pattern='^${BRANCH_NAME}$' \\"
echo "  --build-config=cloudbuild.yaml \\"
echo "  --project=${PROJECT_ID}"

# 4. Build inicial (opcional)
echo ""
echo "🏗️  Para fazer o primeiro build manualmente:"
echo "gcloud builds submit --config cloudbuild.yaml --project=${PROJECT_ID}"

echo ""
echo "✅ Configuração concluída!"
echo "🌐 Após o deploy, sua API estará disponível em:"
echo "https://ktor-sample-[hash]-uc.a.run.app"