#!/bin/bash
set -e
echo "================================================"
echo "   Virtual PC — Setup"
echo "================================================"

export DEBIAN_FRONTEND=noninteractive

# Aguarda Docker daemon ficar disponível (docker-in-docker pode demorar)
echo "Aguardando Docker daemon..."
for i in $(seq 1 30); do
  docker info >/dev/null 2>&1 && break
  echo "  tentativa $i/30..."
  sleep 3
done
docker info >/dev/null 2>&1 || { echo "ERRO: Docker não disponível após 90s"; exit 1; }
echo "Docker pronto."

# Detecta OS alvo (default: linux)
VPC_OS=${VPC_OS:-linux}
echo "OS selecionado: $VPC_OS"

cd /workspaces/$(basename $PWD 2>/dev/null || echo "virtual-pc") 2>/dev/null || true

if [ "$VPC_OS" = "windows" ]; then
  echo "Subindo Windows (dockurr/windows) na porta 8006..."
  echo "Requer KVM — basicLinux32gb tem suporte."
  # Verifica KVM
  if [ -e /dev/kvm ]; then
    echo "KVM disponível."
  else
    echo "AVISO: /dev/kvm não encontrado — Windows pode não iniciar."
    echo "Muda o machine type para basicLinux32gb no Codespace."
  fi
  docker compose -f windows.yml up -d
  echo "Windows iniciando em background — porta 8006 (pode levar 15-20min na primeira vez)"
else
  echo "Subindo Linux KDE na porta 6080..."
  docker compose -f linux.yml up -d
  echo "Linux KDE iniciando — porta 6080 (1-2 min)"
fi

echo "================================================"
echo " Setup concluído! Acessa a porta correta."
echo "================================================"