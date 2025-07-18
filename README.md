# AWS Multi-Region Network Infrastructure

[![Terraform](https://img.shields.io/badge/terraform-%3E%3D1.0-623CE4.svg)](https://www.terraform.io)
[![AWS Provider](https://img.shields.io/badge/aws-%5E5.31-FF9900.svg)](https://registry.terraform.io/providers/hashicorp/aws/latest)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Release](https://img.shields.io/github/v/release/your-org/aws-network-lab)](https://github.com/your-org/aws-network-lab/releases)
[![CI/CD](https://github.com/your-org/aws-network-lab/workflows/Terraform%20Module%20CI%2FCD/badge.svg)](https://github.com/your-org/aws-network-lab/actions)

> 🌍 **Infraestrutura de rede multi-região dinâmica e escalável para AWS**

Este módulo Terraform cria uma infraestrutura de rede robusta e flexível em múltiplas regiões AWS, com suporte completo para configuração dinâmica através de variáveis.

## 🚀 Características

- 🌍 **Multi-região**: Suporte para qualquer número de regiões AWS
- 🔧 **Dinâmico**: Configuração flexível através de variáveis
- 🏗️ **Modular**: Arquitetura bem estruturada e reutilizável
- ✅ **Validado**: Validações automáticas de consistência
- 📊 **Observável**: Outputs detalhados para integração
- 🔒 **Seguro**: Análise de segurança com Checkov
- 📚 **Documentado**: Documentação automática e exemplos

## 📦 Instalação

### Via Terraform Registry

```hcl
module "network" {
  source  = "your-org/aws-network-lab/aws"
  version = "~> 1.0"

  regions = {
    # Sua configuração aqui
  }
}
```

### Via GitHub

```hcl
module "network" {
  source = "github.com/your-org/aws-network-lab"

  regions = {
    # Sua configuração aqui
  }
}
```

Este projeto implementa uma infraestrutura de rede AWS multi-região usando Terraform com arquitetura modular.

## 🏗️ Arquitetura

A infraestrutura provisiona:

- **3 Regiões AWS**: us-east-1, us-west-2, eu-west-1
- **3 VPCs**: Uma por região com CIDR blocks distintos
- **9 Availability Zones**: 3 por região
- **9 Subnets Públicas**: 1 por AZ (total: 9)
- **18 Subnets Privadas**: 2 por AZ (total: 18)
- **9 NAT Gateways**: 1 por AZ para alta disponibilidade
- **3 Internet Gateways**: 1 por VPC

### Diagrama de Rede

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                AWS Account                                      │
├─────────────────────────────────────────────────────────────────────────────────┤
│  Region 1 (us-east-1)    │  Region 2 (us-west-2)    │  Region 3 (eu-west-1)    │
│  ┌─────────────────────┐  │  ┌─────────────────────┐  │  ┌─────────────────────┐  │
│  │ VPC (10.1.0.0/16)  │  │  │ VPC (10.2.0.0/16)  │  │  │ VPC (10.3.0.0/16)  │  │
│  │                     │  │  │                     │  │  │                     │  │
│  │ AZ-a  │ AZ-b  │ AZ-c │  │  │ AZ-a  │ AZ-b  │ AZ-c │  │  │ AZ-a  │ AZ-b  │ AZ-c │  │
│  │ ├──┐  │ ├──┐  │ ├──┐ │  │  │ ├──┐  │ ├──┐  │ ├──┐ │  │  │ ├──┐  │ ├──┐  │ ├──┐ │  │
│  │ │🌐│  │ │🌐│  │ │🌐│ │  │  │ │🌐│  │ │🌐│  │ │🌐│ │  │  │ │🌐│  │ │🌐│  │ │🌐│ │  │
│  │ ├──┤  │ ├──┤  │ ├──┤ │  │  │ ├──┤  │ ├──┤  │ ├──┤ │  │  │ ├──┤  │ ├──┤  │ ├──┤ │  │
│  │ │🔒│  │ │🔒│  │ │🔒│ │  │  │ │🔒│  │ │🔒│  │ │🔒│ │  │  │ │🔒│  │ │🔒│  │ │🔒│ │  │
│  │ │🔒│  │ │🔒│  │ │🔒│ │  │  │ │🔒│  │ │🔒│  │ │🔒│ │  │  │ │🔒│  │ │🔒│  │ │🔒│ │  │
│  │ └──┘  │ └──┘  │ └──┘ │  │  │ └──┘  │ └──┘  │ └──┘ │  │  │ └──┘  │ └──┘  │ └──┘ │  │
│  └─────────────────────┘  │  └─────────────────────┘  │  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────────────┘

🌐 = Subnet Pública
🔒 = Subnet Privada
```

## 📋 Pré-requisitos

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configurado
- Credenciais AWS com permissões adequadas

## 🚀 Começando

### 1. Clone o repositório

```bash
git clone <repository-url>
cd aws-network-lab
```

### 2. Configure as variáveis

```bash
# Opção A: Usando make (recomendado)
make setup

# Opção B: Manual
cd module
cp terraform.tfvars.example terraform.tfvars
# Edite terraform.tfvars conforme necessário
```

### 3. Deploy da infraestrutura

#### Opção A: Script automatizado
```bash
./deploy.sh
```

#### Opção B: Usando Makefile
```bash
make setup    # Cria terraform.tfvars automaticamente
make deploy   # Planeja e aplica
```

#### Opção C: Comandos manuais
```bash
cd module

# Inicializar
terraform init

# Planejar
terraform plan

# Aplicar
terraform apply
```

### 4. Verificar recursos criados

```bash
# Ver outputs
make outputs
# ou
cd module && terraform output

# Listar recursos
make state-list
# ou
cd module && terraform state list

# Validar configuração
./validate.sh
# ou
make validate
```

## 📁 Estrutura do Projeto

```
aws-network-lab/
├── deploy.sh                  # Script de deploy
├── destroy.sh                 # Script de destruição
├── validate.sh                # Script de validação
├── Makefile                   # Comandos padronizados
├── README.md                  # Este arquivo
├── .gitignore                 # Arquivos ignorados pelo Git
└── module/                    # Módulo principal do Terraform
    ├── main.tf                # Configuração principal
    ├── providers.tf           # Configuração dos providers
    ├── variables.tf           # Variáveis globais
    ├── outputs.tf             # Outputs do projeto
    ├── versions.tf            # Versões do Terraform e providers
    ├── backend.tf             # Configuração de backend (opcional)
    ├── examples.tf            # Exemplos de uso
    ├── terraform.tfvars.example # Exemplo de variáveis
    └── modules/               # Submódulos
        ├── region/            # Módulo da região
        │   ├── main.tf        # Recursos da região
        │   ├── variables.tf   # Variáveis do módulo
        │   └── outputs.tf     # Outputs do módulo
        └── ec2-example/       # Módulo de exemplo com EC2
            ├── main.tf        # Instâncias de exemplo
            ├── variables.tf   # Variáveis do módulo
            └── outputs.tf     # Outputs do módulo
```

## 🏗️ Módulos

### Módulo Region

O módulo `region` cria uma infraestrutura completa de rede em uma região AWS:

- **VPC** com DNS habilitado
- **Internet Gateway** para conectividade externa
- **Subnets Públicas** (1 por AZ) com IP público automático
- **Subnets Privadas** (2 por AZ) sem acesso direto à internet
- **NAT Gateways** (1 por AZ) para acesso de saída das subnets privadas
- **Route Tables** apropriadas para cada tipo de subnet
- **Elastic IPs** para os NAT Gateways

## 📊 CIDR Blocks

| Região    | VPC CIDR      | AZ | Subnet Pública | Subnets Privadas        |
|-----------|---------------|----|--------------  |-------------------------|
| us-east-1 | 10.1.0.0/16   | a  | 10.1.1.0/24   | 10.1.11.0/24, 10.1.21.0/24 |
|           |               | b  | 10.1.2.0/24   | 10.1.12.0/24, 10.1.22.0/24 |
|           |               | c  | 10.1.3.0/24   | 10.1.13.0/24, 10.1.23.0/24 |
| us-west-2 | 10.2.0.0/16   | a  | 10.2.1.0/24   | 10.2.11.0/24, 10.2.21.0/24 |
|           |               | b  | 10.2.2.0/24   | 10.2.12.0/24, 10.2.22.0/24 |
|           |               | c  | 10.2.3.0/24   | 10.2.13.0/24, 10.2.23.0/24 |
| eu-west-1 | 10.3.0.0/16   | a  | 10.3.1.0/24   | 10.3.11.0/24, 10.3.21.0/24 |
|           |               | b  | 10.3.2.0/24   | 10.3.12.0/24, 10.3.22.0/24 |
|           |               | c  | 10.3.3.0/24   | 10.3.13.0/24, 10.3.23.0/24 |

## 🔧 Customização

Para personalizar a infraestrutura, edite os valores no arquivo `main.tf`:

- **Regiões**: Altere as regiões AWS utilizadas
- **CIDR Blocks**: Modifique os ranges de IP
- **Availability Zones**: Ajuste as AZs utilizadas
- **Tags**: Adicione tags personalizadas

## 🔧 Configuração Dinâmica de Regiões

### Recursos Dinâmicos

Esta implementação agora suporta **configuração dinâmica de regiões**, permitindo:

- ✅ **Criar qualquer número de regiões** através de variáveis
- ✅ **Começar com 1 região** e expandir gradualmente
- ✅ **Personalizar completamente** cada região
- ✅ **Reutilizar configurações** facilmente

### Como Configurar Regiões

#### 📍 Configuração Básica (1 Região)

Edite `module/terraform.tfvars`:

```hcl
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
```

#### 🌍 Adicionando Novas Regiões

Use o script auxiliar para gerar configurações:

```bash
# Gerar configuração para uma nova região
./add-region.sh us-west-2 10.2

# Exemplo de output:
# us_west_2 = {
#   region_name         = "us-west-2"
#   vpc_cidr           = "10.2.0.0/16"
#   availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
#   ...
# }
```

Depois copie a configuração gerada para o seu `terraform.tfvars`.

#### 🎯 Múltiplas Regiões

```hcl
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
```

### Regiões Suportadas

O projeto inclui providers para as seguintes regiões:

- **US**: `us_east_1`, `us_west_1`, `us_west_2`
- **Europe**: `eu_west_1`, `eu_central_1`  
- **Asia Pacific**: `ap_southeast_1`, `ap_northeast_1`

Para usar outras regiões, adicione o provider correspondente em `module/providers.tf`.

## 💰 Custos Estimados

**Custos aproximados por região (valores em USD):**

- VPC: Gratuito
- Internet Gateway: Gratuito
- Subnets: Gratuito
- NAT Gateways: ~$32/mês cada (3 por região = ~$96/mês)
- Elastic IPs: ~$3.6/mês cada se não associados

**Total estimado: ~$300/mês** para as 3 regiões (principalmente NAT Gateways)

## 🧹 Limpeza

Para destruir toda a infraestrutura:

#### Opção A: Script automatizado
```bash
./destroy.sh
```

#### Opção B: Comando manual
```bash
terraform destroy
```

## 🔐 Segurança

- As subnets privadas não têm acesso direto à internet
- NAT Gateways permitem apenas tráfego de saída das subnets privadas
- Security Groups e NACLs devem ser configurados conforme necessário para suas aplicações

## 📝 Próximos Passos

Esta infraestrutura base pode ser estendida com:

- **VPC Peering** entre regiões
- **Transit Gateway** para conectividade centralizada
- **VPN Connections** para conectividade on-premises
- **Security Groups** e **NACLs** customizados
- **Load Balancers** para distribuição de tráfego
- **Auto Scaling Groups** para alta disponibilidade

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## � Publicação no Terraform Registry

Este módulo está configurado para publicação automática no Terraform Registry. Para criar uma nova versão:

### 1. Preparar Release

```bash
# Use o script automatizado
./release.sh v1.0.0

# Ou manualmente:
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

### 2. CI/CD Automático

O GitHub Actions irá automaticamente:
- ✅ Validar o módulo com `terraform validate`
- 🧪 Executar testes em múltiplas versões do Terraform
- 📚 Gerar documentação com `terraform-docs`
- 🔒 Executar análise de segurança com Checkov
- 📦 Criar release no GitHub
- 🌐 Preparar para publicação no Registry

### 3. Publicar no Registry

1. Acesse [registry.terraform.io](https://registry.terraform.io)
2. Faça login com sua conta GitHub
3. Clique em **"Publish Module"**
4. Selecione este repositório
5. O módulo será publicado automaticamente

### 4. Verificar Publicação

Após a publicação, o módulo estará disponível em:
```
registry.terraform.io/modules/your-org/aws-network-lab/aws
```

### 5. Usar o Módulo Publicado

```hcl
module "network" {
  source  = "your-org/aws-network-lab/aws"
  version = "~> 1.0"
  
  regions = {
    # Sua configuração aqui
  }
}
```

## 📋 Checklist para Registry

- [x] Arquivo `main.tf` presente
- [x] Arquivo `variables.tf` com descrições
- [x] Arquivo `outputs.tf` com descrições
- [x] Arquivo `versions.tf` com versões específicas
- [x] Arquivo `README.md` completo
- [x] Exemplos de uso em `examples/`
- [x] Tags seguindo semantic versioning (`v1.0.0`)
- [x] CI/CD pipeline configurado
- [x] Documentação automática
- [x] Validação e testes automáticos

## �📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.