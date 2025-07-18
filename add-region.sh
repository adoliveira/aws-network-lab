#!/bin/bash

# Script para gerar configuração de nova região
# Uso: ./add-region.sh [region_name] [vpc_cidr_base]

set -e

# Função para mostrar ajuda
show_help() {
    echo "📝 Script para gerar configuração de nova região"
    echo ""
    echo "Uso: $0 [region_name] [vpc_cidr_base]"
    echo ""
    echo "Exemplos:"
    echo "  $0 us-west-1 10.4"
    echo "  $0 eu-central-1 10.5"
    echo "  $0 ap-southeast-1 172.16"
    echo ""
    echo "Regiões AWS disponíveis:"
    echo "  us-east-1, us-east-2, us-west-1, us-west-2"
    echo "  eu-west-1, eu-west-2, eu-central-1, eu-north-1"
    echo "  ap-northeast-1, ap-northeast-2, ap-southeast-1, ap-southeast-2"
    echo "  ap-south-1, ca-central-1, sa-east-1"
    echo ""
}

# Verificar parâmetros
if [ $# -ne 2 ]; then
    show_help
    exit 1
fi

REGION_NAME=$1
VPC_CIDR_BASE=$2

# Converter region_name para key (substituir hífens por underscores)
REGION_KEY=$(echo "$REGION_NAME" | sed 's/-/_/g')

# Obter AZs da região (simulado - em produção você poderia usar AWS CLI)
get_azs() {
    case $REGION_NAME in
        us-east-1)
            echo '["us-east-1a", "us-east-1b", "us-east-1c"]'
            ;;
        us-west-2)
            echo '["us-west-2a", "us-west-2b", "us-west-2c"]'
            ;;
        us-west-1)
            echo '["us-west-1a", "us-west-1c"]'
            ;;
        eu-west-1)
            echo '["eu-west-1a", "eu-west-1b", "eu-west-1c"]'
            ;;
        eu-central-1)
            echo '["eu-central-1a", "eu-central-1b", "eu-central-1c"]'
            ;;
        ap-southeast-1)
            echo '["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]'
            ;;
        ap-northeast-1)
            echo '["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]'
            ;;
        *)
            echo '["'$REGION_NAME'a", "'$REGION_NAME'b", "'$REGION_NAME'c"]'
            ;;
    esac
}

AZS=$(get_azs)
AZ_COUNT=$(echo $AZS | jq length)

echo "🌍 Gerando configuração para região: $REGION_NAME"
echo "🔧 Key da região: $REGION_KEY"
echo "📍 Availability Zones: $AZS"
echo "🌐 VPC CIDR: ${VPC_CIDR_BASE}.0.0/16"
echo ""

# Gerar configuração
cat << EOF
# Adicione esta configuração ao seu terraform.tfvars
  $REGION_KEY = {
    region_name         = "$REGION_NAME"
    vpc_cidr           = "${VPC_CIDR_BASE}.0.0/16"
    availability_zones = $AZS
    
    public_subnet_cidrs = [
EOF

# Gerar CIDRs das subnets públicas
for i in $(seq 1 $AZ_COUNT); do
    echo "      \"${VPC_CIDR_BASE}.${i}.0/24\","
done

cat << EOF
    ]
    
    private_subnet_cidrs = [
EOF

# Gerar CIDRs das subnets privadas
for i in $(seq 1 $AZ_COUNT); do
    PRIVATE1=$((i + 10))
    PRIVATE2=$((i + 20))
    echo "      [\"${VPC_CIDR_BASE}.${PRIVATE1}.0/24\", \"${VPC_CIDR_BASE}.${PRIVATE2}.0/24\"],"
done

cat << EOF
    ]
    
    tags = {
      RegionPurpose = "add-your-purpose-here"
    }
  }

EOF

echo "✅ Configuração gerada!"
echo "📝 Copie o bloco acima e adicione à variável 'regions' no seu terraform.tfvars"
echo ""
echo "⚠️  Lembre-se de:"
echo "   1. Verificar se o provider para $REGION_KEY existe em providers.tf"
echo "   2. Adicionar se necessário:"
echo "      provider \"aws\" {"
echo "        alias  = \"$REGION_KEY\""
echo "        region = \"$REGION_NAME\""
echo "      }"
