output "vpc_id" {
  description = "ID da VPC criada"
  value       = module.network.vpc_ids
}

output "regions_summary" {
  description = "Resumo das regiões criadas"
  value       = module.network.regions_summary
}

output "regions_details" {
  description = "Detalhes completos das regiões"
  value       = module.network.regions
}
