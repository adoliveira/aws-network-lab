# Outputs dinâmicos das regiões criadas
output "regions" {
  description = "Informações de todas as regiões criadas"
  value = merge(
    # us-east-1
    contains(keys(var.regions), "us_east_1") ? {
      us_east_1 = {
        vpc_id              = module.region_us_east_1[0].vpc_id
        vpc_cidr            = module.region_us_east_1[0].vpc_cidr
        public_subnet_ids   = module.region_us_east_1[0].public_subnet_ids
        private_subnet_ids  = module.region_us_east_1[0].private_subnet_ids
        internet_gateway_id = module.region_us_east_1[0].internet_gateway_id
        nat_gateway_ids     = module.region_us_east_1[0].nat_gateway_ids
        availability_zones  = module.region_us_east_1[0].availability_zones
        region_name         = var.regions["us_east_1"].region_name
      }
    } : {},

    # us-west-2
    contains(keys(var.regions), "us_west_2") ? {
      us_west_2 = {
        vpc_id              = module.region_us_west_2[0].vpc_id
        vpc_cidr            = module.region_us_west_2[0].vpc_cidr
        public_subnet_ids   = module.region_us_west_2[0].public_subnet_ids
        private_subnet_ids  = module.region_us_west_2[0].private_subnet_ids
        internet_gateway_id = module.region_us_west_2[0].internet_gateway_id
        nat_gateway_ids     = module.region_us_west_2[0].nat_gateway_ids
        availability_zones  = module.region_us_west_2[0].availability_zones
        region_name         = var.regions["us_west_2"].region_name
      }
    } : {},

    # us-west-1
    contains(keys(var.regions), "us_west_1") ? {
      us_west_1 = {
        vpc_id              = module.region_us_west_1[0].vpc_id
        vpc_cidr            = module.region_us_west_1[0].vpc_cidr
        public_subnet_ids   = module.region_us_west_1[0].public_subnet_ids
        private_subnet_ids  = module.region_us_west_1[0].private_subnet_ids
        internet_gateway_id = module.region_us_west_1[0].internet_gateway_id
        nat_gateway_ids     = module.region_us_west_1[0].nat_gateway_ids
        availability_zones  = module.region_us_west_1[0].availability_zones
        region_name         = var.regions["us_west_1"].region_name
      }
    } : {},

    # eu-west-1
    contains(keys(var.regions), "eu_west_1") ? {
      eu_west_1 = {
        vpc_id              = module.region_eu_west_1[0].vpc_id
        vpc_cidr            = module.region_eu_west_1[0].vpc_cidr
        public_subnet_ids   = module.region_eu_west_1[0].public_subnet_ids
        private_subnet_ids  = module.region_eu_west_1[0].private_subnet_ids
        internet_gateway_id = module.region_eu_west_1[0].internet_gateway_id
        nat_gateway_ids     = module.region_eu_west_1[0].nat_gateway_ids
        availability_zones  = module.region_eu_west_1[0].availability_zones
        region_name         = var.regions["eu_west_1"].region_name
      }
    } : {},

    # eu-central-1
    contains(keys(var.regions), "eu_central_1") ? {
      eu_central_1 = {
        vpc_id              = module.region_eu_central_1[0].vpc_id
        vpc_cidr            = module.region_eu_central_1[0].vpc_cidr
        public_subnet_ids   = module.region_eu_central_1[0].public_subnet_ids
        private_subnet_ids  = module.region_eu_central_1[0].private_subnet_ids
        internet_gateway_id = module.region_eu_central_1[0].internet_gateway_id
        nat_gateway_ids     = module.region_eu_central_1[0].nat_gateway_ids
        availability_zones  = module.region_eu_central_1[0].availability_zones
        region_name         = var.regions["eu_central_1"].region_name
      }
    } : {},

    # ap-southeast-1
    contains(keys(var.regions), "ap_southeast_1") ? {
      ap_southeast_1 = {
        vpc_id              = module.region_ap_southeast_1[0].vpc_id
        vpc_cidr            = module.region_ap_southeast_1[0].vpc_cidr
        public_subnet_ids   = module.region_ap_southeast_1[0].public_subnet_ids
        private_subnet_ids  = module.region_ap_southeast_1[0].private_subnet_ids
        internet_gateway_id = module.region_ap_southeast_1[0].internet_gateway_id
        nat_gateway_ids     = module.region_ap_southeast_1[0].nat_gateway_ids
        availability_zones  = module.region_ap_southeast_1[0].availability_zones
        region_name         = var.regions["ap_southeast_1"].region_name
      }
    } : {},

    # ap-northeast-1
    contains(keys(var.regions), "ap_northeast_1") ? {
      ap_northeast_1 = {
        vpc_id              = module.region_ap_northeast_1[0].vpc_id
        vpc_cidr            = module.region_ap_northeast_1[0].vpc_cidr
        public_subnet_ids   = module.region_ap_northeast_1[0].public_subnet_ids
        private_subnet_ids  = module.region_ap_northeast_1[0].private_subnet_ids
        internet_gateway_id = module.region_ap_northeast_1[0].internet_gateway_id
        nat_gateway_ids     = module.region_ap_northeast_1[0].nat_gateway_ids
        availability_zones  = module.region_ap_northeast_1[0].availability_zones
        region_name         = var.regions["ap_northeast_1"].region_name
      }
    } : {}
  )
}

# Output simplificado apenas com VPC IDs
output "vpc_ids" {
  description = "IDs das VPCs criadas por região"
  value = merge(
    contains(keys(var.regions), "us_east_1") ? {
      us_east_1 = module.region_us_east_1[0].vpc_id
    } : {},
    contains(keys(var.regions), "us_west_2") ? {
      us_west_2 = module.region_us_west_2[0].vpc_id
    } : {},
    contains(keys(var.regions), "us_west_1") ? {
      us_west_1 = module.region_us_west_1[0].vpc_id
    } : {},
    contains(keys(var.regions), "eu_west_1") ? {
      eu_west_1 = module.region_eu_west_1[0].vpc_id
    } : {},
    contains(keys(var.regions), "eu_central_1") ? {
      eu_central_1 = module.region_eu_central_1[0].vpc_id
    } : {},
    contains(keys(var.regions), "ap_southeast_1") ? {
      ap_southeast_1 = module.region_ap_southeast_1[0].vpc_id
    } : {},
    contains(keys(var.regions), "ap_northeast_1") ? {
      ap_northeast_1 = module.region_ap_northeast_1[0].vpc_id
    } : {}
  )
}

# Output com informações resumidas
output "regions_summary" {
  description = "Resumo das regiões criadas"
  value = {
    for region_key, region_config in var.regions : region_key => {
      region_name = region_config.region_name
      vpc_cidr    = region_config.vpc_cidr
      az_count    = length(region_config.availability_zones)
      status      = "configured"
    }
  }
}
