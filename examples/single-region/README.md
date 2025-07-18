# Exemplo: Região Única

Este exemplo demonstra como criar uma infraestrutura de rede em uma única região AWS.

## Recursos Criados

- 1 VPC em us-east-1
- 3 Subnets públicas (uma por AZ)
- 6 Subnets privadas (duas por AZ)
- 3 NAT Gateways (um por AZ)
- 1 Internet Gateway
- Route tables apropriadas

## Como Usar

1. Configure suas credenciais AWS
2. Execute os comandos:

```bash
terraform init
terraform plan
terraform apply
```

## Limpeza

```bash
terraform destroy
```
