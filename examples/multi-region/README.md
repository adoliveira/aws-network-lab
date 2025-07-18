# Exemplo: Multi-Região

Este exemplo demonstra como criar uma infraestrutura de rede em múltiplas regiões AWS.

## Recursos Criados

### Região us-east-1 (Virginia - Primary)
- VPC: 10.1.0.0/16
- 3 Subnets públicas + 6 privadas
- 3 NAT Gateways

### Região us-west-2 (Oregon - Secondary)  
- VPC: 10.2.0.0/16
- 2 Subnets públicas + 4 privadas
- 2 NAT Gateways

### Região eu-west-1 (Ireland - Europe)
- VPC: 10.3.0.0/16
- 2 Subnets públicas + 4 privadas
- 2 NAT Gateways

## Como Usar

1. Configure suas credenciais AWS com acesso às regiões
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
