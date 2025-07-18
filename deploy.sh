#!/bin/bash

# Script para deploy da infraestrutura AWS Network Lab

set -e

echo "🚀 Iniciando deploy da infraestrutura AWS Network Lab"

# Verificar se o Terraform está instalado
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform não está instalado. Por favor, instale o Terraform primeiro."
    exit 1
fi

# Verificar se o AWS CLI está instalado
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI não está instalado. Por favor, instale o AWS CLI primeiro."
    exit 1
fi

# Verificar se as credenciais AWS estão configuradas
if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ Credenciais AWS não estão configuradas. Execute 'aws configure' primeiro."
    exit 1
fi

echo "✅ Pré-requisitos verificados"

# Navegar para o diretório do módulo
cd module

# Criar arquivo terraform.tfvars se não existir
if [ ! -f terraform.tfvars ]; then
    echo "📝 Criando arquivo terraform.tfvars"
    cp terraform.tfvars.example terraform.tfvars
    echo "⚠️  Edite o arquivo terraform.tfvars conforme necessário antes de continuar"
    read -p "Pressione Enter para continuar após editar o arquivo..."
fi

# Inicializar Terraform
echo "🔄 Inicializando Terraform..."
terraform init

# Validar configuração
echo "✅ Validando configuração..."
terraform validate

# Planejar mudanças
echo "📋 Planejando mudanças..."
terraform plan -out=tfplan

# Confirmar aplicação
echo "🤔 Deseja aplicar as mudanças? (y/N)"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "🚀 Aplicando mudanças..."
    terraform apply tfplan
    echo "✅ Deploy concluído com sucesso!"
    echo "📊 Para ver os outputs, execute: terraform output"
else
    echo "❌ Deploy cancelado"
    rm -f tfplan
fi
