# Exemplos de Uso

Este diretório contém exemplos práticos de como usar o módulo AWS Multi-Region Network Infrastructure.

## 📁 Estrutura dos Exemplos

- `single-region/` - Exemplo básico com uma única região
- `multi-region/` - Exemplo completo com múltiplas regiões
- `advanced/` - Exemplo avançado com configurações customizadas

## 🚀 Executando os Exemplos

Para qualquer exemplo:

```bash
cd examples/[nome-do-exemplo]
terraform init
terraform plan
terraform apply
```

## 🧹 Limpeza

```bash
terraform destroy
```

## 📝 Pré-requisitos

- Terraform >= 1.0
- Credenciais AWS configuradas
- Permissões necessárias para criar VPCs, subnets, etc.
