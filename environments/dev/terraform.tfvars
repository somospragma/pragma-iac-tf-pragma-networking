#################################################
# Variables Generales - Provider
#################################################

aws_region  = "us-east-1"
environment = "dev"
client      = "pragma"
project     = "transfers"

common_tags = {
  client      = "pragma"
  project     = "transfers"
  environment = "dev"
  owner       = "cloudops"
  area        = "infrastructure"
  provisioned = "terraform"
  application = "networking"
  territory   = "peru"
  country     = "pe"
  cost-center = "9952"
}

additional_tags = {}

# CIDR /22 (10.30.0.0 - 10.30.3.255) — service /24 x2,
# public/private/database /26 x2.
#################################################
# Variables VPC
#################################################
vpc_cidr_block                 = "10.30.0.0/22"
vpc_instance_tenancy           = "default"
vpc_enable_dns_support         = true
vpc_enable_dns_hostnames       = true
vpc_flow_log_retention_in_days = 7
vpc_create_igw                 = true
vpc_create_nat                 = true
vpc_nat_type                   = "regional"
vpc_nat_regional_mode          = "auto"

#################################################
# Variables Subnet públicas
#################################################
public_subnet_1_cidr_block        = "10.30.2.0/26"
public_subnet_1_availability_zone = "us-east-1a"
public_subnet_2_cidr_block        = "10.30.2.64/26"
public_subnet_2_availability_zone = "us-east-1b"

#################################################
# Variables Subnet privadas
#################################################
private_subnet_1_cidr_block        = "10.30.2.128/26"
private_subnet_1_availability_zone = "us-east-1a"
private_subnet_2_cidr_block        = "10.30.2.192/26"
private_subnet_2_availability_zone = "us-east-1b"

#################################################
# Variables Subnet servicio
#################################################
service_subnet_1_cidr_block        = "10.30.0.0/24"
service_subnet_1_availability_zone = "us-east-1a"
service_subnet_2_cidr_block        = "10.30.1.0/24"
service_subnet_2_availability_zone = "us-east-1b"

#################################################
# Variables Subnet database
#################################################
database_subnet_1_cidr_block        = "10.30.3.0/26"
database_subnet_1_availability_zone = "us-east-1a"
database_subnet_2_cidr_block        = "10.30.3.64/26"
database_subnet_2_availability_zone = "us-east-1b"

#################################################
# Módulo VPC Endpoints Gateway
#################################################
vpc_endpoints_config = {
  "s3" = {
    service_name = "com.amazonaws.us-east-1.s3"
  }
  "dynamodb" = {
    service_name = "com.amazonaws.us-east-1.dynamodb"
  }
}

#################################################
# Security Groups
# Sin reglas definidas todavía — módulo estructuralmente listo, sg_config
# vacío hasta que se definan los requerimientos de seguridad.
#################################################
sg_config = {}

#################################################
# Deployment Role
# NO declarar deploy_role_arn aquí — se inyecta vía `terraform plan
# -var="deploy_role_arn=$(AWS_DEPLOY_ROLE)"` en el pipeline. -var-file
# (este .tfvars) tiene precedencia sobre -var cuando ambos van en la misma
# línea y -var-file va después; declarar esta variable aquí (aunque vacía)
# sobrescribe el valor real de la Library con "" y el provider "principal"
# falla con "role_arn is required, but no definition was found".
#################################################
