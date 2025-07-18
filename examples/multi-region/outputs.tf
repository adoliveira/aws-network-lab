output "all_regions" {
  description = "Informações de todas as regiões criadas"
  value = {
    vpc_ids         = module.network.vpc_ids
    regions_summary = module.network.regions_summary
    regions_details = module.network.regions
  }
}

output "region_summary" {
  description = "Resumo dos recursos por região"
  value       = module.network.regions_summary
}
