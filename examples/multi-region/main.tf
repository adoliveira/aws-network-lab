terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.31"
    }
  }
}

# Providers para múltiplas regiões
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us_west_2"
  region = "us-west-2"
}

provider "aws" {
  alias  = "eu_west_1"
  region = "eu-west-1"
}

module "network" {
  source = "../../"

  # Configuração para múltiplas regiões
  regions = {
    # Região Primary (Virginia)
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
        ["10.1.11.0/24", "10.1.21.0/24"], # us-east-1a private
        ["10.1.12.0/24", "10.1.22.0/24"], # us-east-1b private
        ["10.1.13.0/24", "10.1.23.0/24"]  # us-east-1c private
      ]

      tags = {
        Environment = "production"
        Role        = "primary"
        Region      = "us-east-1"
      }
    }

    # Região Secondary (Oregon)
    us_west_2 = {
      region_name        = "us-west-2"
      vpc_cidr           = "10.2.0.0/16"
      availability_zones = ["us-west-2a", "us-west-2b"]

      public_subnet_cidrs = [
        "10.2.1.0/24", # us-west-2a public
        "10.2.2.0/24"  # us-west-2b public
      ]

      private_subnet_cidrs = [
        ["10.2.11.0/24", "10.2.21.0/24"], # us-west-2a private
        ["10.2.12.0/24", "10.2.22.0/24"]  # us-west-2b private
      ]

      tags = {
        Environment = "production"
        Role        = "secondary"
        Region      = "us-west-2"
      }
    }

    # Região Europe (Ireland)
    eu_west_1 = {
      region_name        = "eu-west-1"
      vpc_cidr           = "10.3.0.0/16"
      availability_zones = ["eu-west-1a", "eu-west-1b"]

      public_subnet_cidrs = [
        "10.3.1.0/24", # eu-west-1a public
        "10.3.2.0/24"  # eu-west-1b public
      ]

      private_subnet_cidrs = [
        ["10.3.11.0/24", "10.3.21.0/24"], # eu-west-1a private
        ["10.3.12.0/24", "10.3.22.0/24"]  # eu-west-1b private
      ]

      tags = {
        Environment = "production"
        Role        = "europe"
        Region      = "eu-west-1"
        Compliance  = "GDPR"
      }
    }
  }
}
