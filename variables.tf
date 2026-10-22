######################################################################
# Variables Generales / Provider
######################################################################
variable "deploy_role_arn" {
  description = "IaC Deployment Role"
  type        = string
}

variable "aws_region" {
  description = "Region to deploy the IaC"
  type        = string
}

variable "additional_tags" {
  description = "Tags adicionales para todos los recursos del módulo VPC"
  type        = map(string)
  default     = {}
}

variable "common_tags" {
  description = "Common tags applied to resources"
  type        = map(string)
}

variable "environment" {
  description = "Project Environment"
  type        = string
}

variable "client" {
  description = "Project Client"
  type        = string
}

variable "project" {
  description = "Project Name"
  type        = string
}

######################################################################
# Variables VPC
######################################################################
variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
}

variable "vpc_instance_tenancy" {
  description = "Tenancy for instances created in the VPC"
  type        = string
  default     = "default"
}

variable "vpc_enable_dns_support" {
  description = "DNS support enabled"
  type        = bool
  default     = true
}

variable "vpc_enable_dns_hostnames" {
  description = "DNS hostnames enabled for instances"
  type        = bool
  default     = true
}

variable "vpc_flow_log_retention_in_days" {
  description = "VPC flow logs retention time in days"
  type        = number
  default     = 7
}

variable "vpc_create_igw" {
  description = "Create Internet Gateway"
  type        = bool
  default     = true
}

variable "vpc_create_nat" {
  description = "Create NAT Gateway"
  type        = bool
  default     = true
}

variable "vpc_nat_type" {
  description = "NAT Gateway mode: 'zonal' o 'regional'"
  type        = string
  default     = "regional"
}

variable "vpc_nat_regional_mode" {
  description = "Regional NAT Gateway IP management mode: 'auto' o 'manual'"
  type        = string
  default     = "auto"
}

######################################################################
# Variables Subnets - Public
######################################################################
variable "public_subnet_1_cidr_block" {
  type = string
}
variable "public_subnet_1_availability_zone" {
  type = string
}
variable "public_subnet_2_cidr_block" {
  type = string
}
variable "public_subnet_2_availability_zone" {
  type = string
}

######################################################################
# Variables Subnets - Private
######################################################################
variable "private_subnet_1_cidr_block" {
  type = string
}
variable "private_subnet_1_availability_zone" {
  type = string
}
variable "private_subnet_2_cidr_block" {
  type = string
}
variable "private_subnet_2_availability_zone" {
  type = string
}

######################################################################
# Variables Subnets - Service
######################################################################
variable "service_subnet_1_cidr_block" {
  type = string
}
variable "service_subnet_1_availability_zone" {
  type = string
}
variable "service_subnet_2_cidr_block" {
  type = string
}
variable "service_subnet_2_availability_zone" {
  type = string
}

######################################################################
# Variables Subnets - Database
######################################################################
variable "database_subnet_1_cidr_block" {
  type = string
}
variable "database_subnet_1_availability_zone" {
  type = string
}
variable "database_subnet_2_cidr_block" {
  type = string
}
variable "database_subnet_2_availability_zone" {
  type = string
}

######################################################################
# Variables VPC Endpoints (Gateway - S3 / DynamoDB)
######################################################################
variable "vpc_endpoints_config" {
  description = "VPC Endpoints Gateway config"
  type = map(object({
    service_name = string
  }))
  default = {}
}

######################################################################
# Variables Security Groups
######################################################################
variable "sg_config" {
  description = "Configuración de Security Groups"
  type = map(object({
    description     = string
    vpc_id          = optional(string, "")
    additional_tags = optional(map(string), {})
    ingress = list(object({
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = list(string)
      security_groups = list(string)
      prefix_list_ids = list(string)
      self            = bool
      description     = string
    }))
    egress = list(object({
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = list(string)
      prefix_list_ids = list(string)
      security_groups = list(string)
      self            = bool
      description     = string
    }))
  }))
  default = {}
}
