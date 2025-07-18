# Módulos para cada região com providers específicos
# us-east-1
module "region_us_east_1" {
  count  = contains(keys(var.regions), "us_east_1") ? 1 : 0
  source = "./modules/region"

  providers = {
    aws = aws.us_east_1
  }

  region_name          = var.regions["us_east_1"].region_name
  vpc_cidr             = var.regions["us_east_1"].vpc_cidr
  availability_zones   = var.regions["us_east_1"].availability_zones
  public_subnet_cidrs  = var.regions["us_east_1"].public_subnet_cidrs
  private_subnet_cidrs = var.regions["us_east_1"].private_subnet_cidrs

  tags = merge(
    var.common_tags,
    {
      Environment = var.environment
      Project     = var.project_name
      Region      = var.regions["us_east_1"].region_name
    },
    var.regions["us_east_1"].tags
  )
}

# us-west-2
module "region_us_west_2" {
  count  = contains(keys(var.regions), "us_west_2") ? 1 : 0
  source = "./modules/region"

  providers = {
    aws = aws.us_west_2
  }

  region_name          = var.regions["us_west_2"].region_name
  vpc_cidr             = var.regions["us_west_2"].vpc_cidr
  availability_zones   = var.regions["us_west_2"].availability_zones
  public_subnet_cidrs  = var.regions["us_west_2"].public_subnet_cidrs
  private_subnet_cidrs = var.regions["us_west_2"].private_subnet_cidrs

  tags = merge(
    var.common_tags,
    {
      Environment = var.environment
      Project     = var.project_name
      Region      = var.regions["us_west_2"].region_name
    },
    var.regions["us_west_2"].tags
  )
}

# us-west-1
module "region_us_west_1" {
  count  = contains(keys(var.regions), "us_west_1") ? 1 : 0
  source = "./modules/region"

  providers = {
    aws = aws.us_west_1
  }

  region_name          = var.regions["us_west_1"].region_name
  vpc_cidr             = var.regions["us_west_1"].vpc_cidr
  availability_zones   = var.regions["us_west_1"].availability_zones
  public_subnet_cidrs  = var.regions["us_west_1"].public_subnet_cidrs
  private_subnet_cidrs = var.regions["us_west_1"].private_subnet_cidrs

  tags = merge(
    var.common_tags,
    {
      Environment = var.environment
      Project     = var.project_name
      Region      = var.regions["us_west_1"].region_name
    },
    var.regions["us_west_1"].tags
  )
}

# eu-west-1
module "region_eu_west_1" {
  count  = contains(keys(var.regions), "eu_west_1") ? 1 : 0
  source = "./modules/region"

  providers = {
    aws = aws.eu_west_1
  }

  region_name          = var.regions["eu_west_1"].region_name
  vpc_cidr             = var.regions["eu_west_1"].vpc_cidr
  availability_zones   = var.regions["eu_west_1"].availability_zones
  public_subnet_cidrs  = var.regions["eu_west_1"].public_subnet_cidrs
  private_subnet_cidrs = var.regions["eu_west_1"].private_subnet_cidrs

  tags = merge(
    var.common_tags,
    {
      Environment = var.environment
      Project     = var.project_name
      Region      = var.regions["eu_west_1"].region_name
    },
    var.regions["eu_west_1"].tags
  )
}

# eu-central-1
module "region_eu_central_1" {
  count  = contains(keys(var.regions), "eu_central_1") ? 1 : 0
  source = "./modules/region"

  providers = {
    aws = aws.eu_central_1
  }

  region_name          = var.regions["eu_central_1"].region_name
  vpc_cidr             = var.regions["eu_central_1"].vpc_cidr
  availability_zones   = var.regions["eu_central_1"].availability_zones
  public_subnet_cidrs  = var.regions["eu_central_1"].public_subnet_cidrs
  private_subnet_cidrs = var.regions["eu_central_1"].private_subnet_cidrs

  tags = merge(
    var.common_tags,
    {
      Environment = var.environment
      Project     = var.project_name
      Region      = var.regions["eu_central_1"].region_name
    },
    var.regions["eu_central_1"].tags
  )
}

# ap-southeast-1
module "region_ap_southeast_1" {
  count  = contains(keys(var.regions), "ap_southeast_1") ? 1 : 0
  source = "./modules/region"

  providers = {
    aws = aws.ap_southeast_1
  }

  region_name          = var.regions["ap_southeast_1"].region_name
  vpc_cidr             = var.regions["ap_southeast_1"].vpc_cidr
  availability_zones   = var.regions["ap_southeast_1"].availability_zones
  public_subnet_cidrs  = var.regions["ap_southeast_1"].public_subnet_cidrs
  private_subnet_cidrs = var.regions["ap_southeast_1"].private_subnet_cidrs

  tags = merge(
    var.common_tags,
    {
      Environment = var.environment
      Project     = var.project_name
      Region      = var.regions["ap_southeast_1"].region_name
    },
    var.regions["ap_southeast_1"].tags
  )
}

# ap-northeast-1
module "region_ap_northeast_1" {
  count  = contains(keys(var.regions), "ap_northeast_1") ? 1 : 0
  source = "./modules/region"

  providers = {
    aws = aws.ap_northeast_1
  }

  region_name          = var.regions["ap_northeast_1"].region_name
  vpc_cidr             = var.regions["ap_northeast_1"].vpc_cidr
  availability_zones   = var.regions["ap_northeast_1"].availability_zones
  public_subnet_cidrs  = var.regions["ap_northeast_1"].public_subnet_cidrs
  private_subnet_cidrs = var.regions["ap_northeast_1"].private_subnet_cidrs

  tags = merge(
    var.common_tags,
    {
      Environment = var.environment
      Project     = var.project_name
      Region      = var.regions["ap_northeast_1"].region_name
    },
    var.regions["ap_northeast_1"].tags
  )
}
