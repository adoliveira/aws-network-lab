# AWS Multi-Region Network Infrastructure

Este módulo Terraform cria uma infraestrutura de rede multi-região na AWS com suporte dinâmico para qualquer número de regiões.

## Características

- 🌍 **Multi-região**: Suporte para qualquer número de regiões AWS
- 🔧 **Dinâmico**: Configuração flexível através de variáveis
- 🏗️ **Modular**: Arquitetura bem estruturada e reutilizável
- ✅ **Validado**: Validações automáticas de consistência
- 📊 **Observável**: Outputs detalhados para integração

## Recursos Criados

Por região configurada:
- **1 VPC** com DNS habilitado
- **1 Internet Gateway**
- **N Subnets Públicas** (1 por AZ)
- **2N Subnets Privadas** (2 por AZ) 
- **N NAT Gateways** (1 por AZ para alta disponibilidade)
- **Route Tables** apropriadas
- **Elastic IPs** para NAT Gateways

## Uso

### Exemplo Básico (1 Região)

```hcl
module "network" {
  source = "your-org/network/aws"
  version = "~> 1.0"

  regions = {
    us_east_1 = {
      region_name         = "us-east-1"
      vpc_cidr           = "10.1.0.0/16"
      availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
      
      public_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
      private_subnet_cidrs = [
        ["10.1.11.0/24", "10.1.21.0/24"], # AZ-a subnets privadas
        ["10.1.12.0/24", "10.1.22.0/24"], # AZ-b subnets privadas
        ["10.1.13.0/24", "10.1.23.0/24"]  # AZ-c subnets privadas
      ]
      
      tags = {
        RegionPurpose = "primary"
      }
    }
  }

  common_tags = {
    Project     = "my-project"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

### Exemplo Multi-Região

```hcl
module "network" {
  source = "your-org/network/aws"
  version = "~> 1.0"

  regions = {
    # Região primária
    us_east_1 = {
      region_name         = "us-east-1"
      vpc_cidr           = "10.1.0.0/16"
      availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
      public_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
      private_subnet_cidrs = [
        ["10.1.11.0/24", "10.1.21.0/24"],
        ["10.1.12.0/24", "10.1.22.0/24"],
        ["10.1.13.0/24", "10.1.23.0/24"]
      ]
      tags = { RegionPurpose = "primary" }
    },
    
    # Região secundária
    us_west_2 = {
      region_name         = "us-west-2"
      vpc_cidr           = "10.2.0.0/16"
      availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
      public_subnet_cidrs = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
      private_subnet_cidrs = [
        ["10.2.11.0/24", "10.2.21.0/24"],
        ["10.2.12.0/24", "10.2.22.0/24"],
        ["10.2.13.0/24", "10.2.23.0/24"]
      ]
      tags = { RegionPurpose = "secondary" }
    }
  }
}
```

## Argumentos

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|---------|-------------|
| `regions` | Configuração das regiões a serem criadas | `map(object)` | `{}` | sim |
| `common_tags` | Tags comuns aplicadas a todos os recursos | `map(string)` | `{}` | não |
| `project_name` | Nome do projeto | `string` | `"aws-network-lab"` | não |
| `environment` | Ambiente (dev, staging, prod) | `string` | `"lab"` | não |

### Objeto `regions`

Cada chave no map `regions` deve conter:

| Nome | Descrição | Tipo | Obrigatório |
|------|-----------|------|-------------|
| `region_name` | Nome da região AWS | `string` | sim |
| `vpc_cidr` | CIDR block da VPC | `string` | sim |
| `availability_zones` | Lista das AZs a usar | `list(string)` | sim |
| `public_subnet_cidrs` | CIDRs das subnets públicas | `list(string)` | sim |
| `private_subnet_cidrs` | CIDRs das subnets privadas (2 por AZ) | `list(list(string))` | sim |
| `tags` | Tags específicas da região | `map(string)` | não |

## Outputs

| Nome | Descrição |
|------|-----------|
| `regions` | Informações detalhadas de todas as regiões criadas |
| `vpc_ids` | IDs das VPCs por região |
| `regions_summary` | Resumo das regiões configuradas |

### Estrutura do Output `regions`

```hcl
{
  "region_key" = {
    vpc_id              = "vpc-xxxxx"
    vpc_cidr            = "10.1.0.0/16"
    public_subnet_ids   = ["subnet-xxxxx", "subnet-yyyyy"]
    private_subnet_ids  = ["subnet-zzzzz", "subnet-aaaaa"]
    internet_gateway_id = "igw-xxxxx"
    nat_gateway_ids     = ["nat-xxxxx", "nat-yyyyy"]
    availability_zones  = ["us-east-1a", "us-east-1b"]
    region_name         = "us-east-1"
  }
}
```

## Regiões Suportadas

- **US**: us-east-1, us-west-1, us-west-2
- **Europe**: eu-west-1, eu-central-1
- **Asia Pacific**: ap-southeast-1, ap-northeast-1

Para usar outras regiões, elas devem estar configuradas nos providers.

## Validações

O módulo inclui validações automáticas:

- ✅ Número de AZs = Número de subnets públicas
- ✅ Número de AZs = Número de grupos de subnets privadas
- ✅ CIDRs válidos para VPC e subnets

## Exemplos de CIDR

### Pequeno (1 região, 2 AZs)
```hcl
vpc_cidr           = "10.1.0.0/16"
public_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = [
  ["10.1.11.0/24", "10.1.21.0/24"],
  ["10.1.12.0/24", "10.1.22.0/24"]
]
```

### Médio (1 região, 3 AZs) 
```hcl
vpc_cidr           = "10.1.0.0/16"
public_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
private_subnet_cidrs = [
  ["10.1.11.0/24", "10.1.21.0/24"],
  ["10.1.12.0/24", "10.1.22.0/24"],
  ["10.1.13.0/24", "10.1.23.0/24"]
]
```

## Requisitos

| Nome | Versão |
|------|--------|
| terraform | >= 1.0 |
| aws | ~> 5.0 |

## Providers

| Nome | Versão |
|------|--------|
| aws | ~> 5.0 |

## Recursos

Este módulo cria os seguintes recursos:

- aws_vpc
- aws_internet_gateway
- aws_subnet (públicas e privadas)
- aws_nat_gateway
- aws_eip
- aws_route_table
- aws_route_table_association

## Custos Estimados

**Por região:**
- VPC, IGW, Subnets: Gratuito
- NAT Gateways: ~$32/mês cada (1 por AZ)
- Elastic IPs: ~$3.6/mês cada (se não associados)

**Exemplo:** 1 região com 3 AZs = ~$96/mês em NAT Gateways

## Licença

MIT

## Autores

Criado e mantido pela equipe de DevOps.
