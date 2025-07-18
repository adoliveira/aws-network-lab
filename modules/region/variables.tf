variable "region_name" {
  description = "Nome da região AWS"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block para a VPC"
  type        = string
}

variable "availability_zones" {
  description = "Lista das Availability Zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Lista de CIDR blocks para as subnets públicas"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Lista de listas de CIDR blocks para as subnets privadas (duas por AZ)"
  type        = list(list(string))
}

variable "tags" {
  description = "Tags a serem aplicadas aos recursos"
  type        = map(string)
  default     = {}
}
