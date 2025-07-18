#!/bin/bash

# Script para destruir a infraestrutura AWS Network Lab

set -e

echo "🗑️  Iniciando destruição da infraestrutura AWS Network Lab"

# Navegar para o diretório do módulo
cd module

# Verificar se existe um estado do Terraform
if [ ! -f terraform.tfstate ]; then
    echo "❌ Arquivo terraform.tfstate não encontrado. Não há infraestrutura para destruir."
    exit 1
fi

echo "⚠️  ATENÇÃO: Esta ação irá DESTRUIR TODA a infraestrutura criada!"
echo "⚠️  Esta ação é IRREVERSÍVEL!"
echo ""
echo "🤔 Tem certeza que deseja continuar? (yes/NO)"
read -r response

if [[ "$response" == "yes" ]]; then
    echo "🔄 Planejando destruição..."
    terraform plan -destroy -out=destroy.tfplan
    
    echo ""
    echo "🤔 Confirma a destruição da infraestrutura? (yes/NO)"
    read -r confirm
    
    if [[ "$confirm" == "yes" ]]; then
        echo "💥 Destruindo infraestrutura..."
        terraform apply destroy.tfplan
        echo "✅ Infraestrutura destruída com sucesso!"
        rm -f destroy.tfplan
    else
        echo "❌ Destruição cancelada"
        rm -f destroy.tfplan
    fi
else
    echo "❌ Destruição cancelada"
fi
