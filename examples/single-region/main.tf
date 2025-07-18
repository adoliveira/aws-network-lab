terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.31"
    }
  }
}

# Configure o provider para a região principal
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

module "network" {
  source = "../../"

  # Configuração para uma única região
  regions = {
    us_east_1 = {
      region_name        = "us-east-1"
      vpc_cidr           = "10.1.0.0/16"
      availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

      public_subnet_cidrs = [
        "10.1.1.0/24", # us-east-1a public
        "10.1.2.0/24", # us-east-1b public
        "10.1.3.0/24"  # us-east-1c public
      ]

      private_subnet_cidrs = [
        ["10.1.11.0/24", "10.1.21.0/24"], # us-east-1a private subnets
        ["10.1.12.0/24", "10.1.22.0/24"], # us-east-1b private subnets
        ["10.1.13.0/24", "10.1.23.0/24"]  # us-east-1c private subnets
      ]

      tags = {
        Environment = "development"
        Project     = "network-example"
        Region      = "primary"
      }
    }
  }


}
