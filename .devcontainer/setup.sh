#!/bin/bash
set -e
echo "================================================"
echo "   Virtual PC — Setup"
echo "================================================"

export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq \
  docker-compose-plugin \
  curl wget git htop \
  2>/dev/null || true

# Detecta OS alvo (default: linux)
VPC_OS=${VPC_OS:-linux}
echo "OS selecionado: $VPC_OS"

if [ "$VPC_OS" = "windows" ]; then
  echo "Subindo Windows (dockurr/windows) na porta 8006..."
  docker compose -f windows.yml up -d
  echo "Windows iniciando — acessa a porta 8006 (pode levar 15-20min)"
else
  echo "Subindo Linux KDE na porta 6080..."
  docker compose -f linux.yml up -d
  echo "Linux pronto — acessa a porta 6080"
fi

echo "================================================"
echo " Setup concluído!"
echo "================================================"