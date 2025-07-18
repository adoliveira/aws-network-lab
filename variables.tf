variable "aws_profile" {
  description = "Perfil AWS a ser utilizado"
  type        = string
  default     = "default"
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "aws-network-lab"
}

variable "environment" {
  description = "Ambiente (dev, sdx, prd)"
  type        = string
  default     = "lab"
}

variable "regions" {
  description = "Configuração das regiões AWS a serem criadas"
  type = map(object({
    region_name          = string
    vpc_cidr             = string
    availability_zones   = list(string)
    public_subnet_cidrs  = list(string)
    private_subnet_cidrs = list(list(string))
    tags                 = optional(map(string), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for region_key, region in var.regions :
      length(region.availability_zones) == length(region.public_subnet_cidrs)
    ])
    error_message = "O número de availability_zones deve ser igual ao número de public_subnet_cidrs para cada região."
  }

  validation {
    condition = alltrue([
      for region_key, region in var.regions :
      length(region.availability_zones) == length(region.private_subnet_cidrs)
    ])
    error_message = "O número de availability_zones deve ser igual ao número de private_subnet_cidrs para cada região."
  }
}

variable "common_tags" {
  description = "Tags comuns aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}
