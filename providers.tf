# Configuração de providers para regiões
# Nota: Providers devem ser configurados estaticamente, então incluímos os mais comuns
# Adicione novos providers conforme necessário para suas regiões

provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
  profile = var.aws_profile
}

provider "aws" {
  alias   = "us_west_2"
  region  = "us-west-2"
  profile = var.aws_profile
}

provider "aws" {
  alias   = "us_west_1"
  region  = "us-west-1"
  profile = var.aws_profile
}

provider "aws" {
  alias   = "eu_west_1"
  region  = "eu-west-1"
  profile = var.aws_profile
}

provider "aws" {
  alias   = "eu_central_1"
  region  = "eu-central-1"
  profile = var.aws_profile
}

provider "aws" {
  alias   = "ap_southeast_1"
  region  = "ap-southeast-1"
  profile = var.aws_profile
}

provider "aws" {
  alias   = "ap_northeast_1"
  region  = "ap-northeast-1"
  profile = var.aws_profile
}

# Adicione mais providers conforme necessário para outras regiões
