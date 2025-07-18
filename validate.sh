#!/bin/bash

# Script para validar a configuração do Terraform

set -e

echo "🔍 Validando configuração do AWS Network Lab"

# Verificar se o Terraform está instalado
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform não está instalado"
    exit 1
fi

echo "✅ Terraform encontrado: $(terraform version | head -n1)"

# Verificar estrutura de arquivos
echo "📁 Verificando estrutura de arquivos..."

# Trabalhar no diretório raiz (módulo principal)
required_files=(
    "main.tf"
    "providers.tf"
    "variables.tf"
    "outputs.tf"
    "versions.tf"
    "modules/region/main.tf"
    "modules/region/variables.tf"
    "modules/region/outputs.tf"
    "examples/single-region/main.tf"
    "examples/multi-region/main.tf"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file não encontrado"
        exit 1
    fi
done

# Verificar sintaxe do Terraform
echo "🔧 Verificando sintaxe do Terraform..."

# Inicializar se necessário (sem baixar providers na internet)
if [ ! -d ".terraform" ]; then
    echo "🔄 Inicializando Terraform (primeira vez)..."
    terraform init -backend=false > /dev/null 2>&1
fi

# Validar sintaxe
if terraform validate > /dev/null 2>&1; then
    echo "✅ Sintaxe do Terraform válida"
else
    echo "❌ Erro na sintaxe do Terraform:"
    terraform validate
    exit 1
fi

# Formatar código
echo "📝 Verificando formatação..."
if terraform fmt -check=true -recursive > /dev/null 2>&1; then
    echo "✅ Código bem formatado"
else
    echo "⚠️  Código precisa ser formatado. Execute: terraform fmt -recursive"
fi

# Verificar se terraform.tfvars existe
if [ -f "terraform.tfvars" ]; then
    echo "✅ terraform.tfvars encontrado"
else
    echo "⚠️  terraform.tfvars não encontrado. Copie de terraform.tfvars.example"
fi

echo ""
echo "🎉 Validação concluída com sucesso!"
echo "💡 Para fazer deploy: ./deploy.sh"
