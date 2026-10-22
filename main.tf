############################################################################
# 1. VPC
#    Standalone — NAT propio (create_nat = var.vpc_create_nat, modo regional)
#    subnet_config viene de locals.tf — include_nat controlado por local.create_nat
############################################################################
module "vpc" {
  source = "github.com/somospragma/cloudops-ref-repo-aws-vpc-terraform?ref=v1.0.4"

  providers = {
    aws.project = aws.principal
  }

  aws_region  = var.aws_region
  environment = var.environment
  client      = var.client
  project     = var.project

  cidr_block                 = var.vpc_cidr_block
  instance_tenancy           = var.vpc_instance_tenancy
  enable_dns_support         = var.vpc_enable_dns_support
  enable_dns_hostnames       = var.vpc_enable_dns_hostnames
  flow_log_retention_in_days = var.vpc_flow_log_retention_in_days

  subnet_config = local.subnet_config_transformed

  create_igw        = var.vpc_create_igw
  create_nat        = local.create_nat
  nat_mode          = var.vpc_nat_type
  nat_regional_mode = var.vpc_nat_regional_mode

  additional_tags = var.additional_tags
}

############################################################################
# 2. Security Groups
#    Módulo incluido — sg_config vacío por defecto (sin reglas aún).
#    La seguridad de compute se gestiona en las capas superiores.
############################################################################
module "security_groups" {
  source = "github.com/somospragma/cloudops-ref-repo-aws-sg-terraform?ref=v1.0.2"

  providers = {
    aws.project = aws.principal
  }

  client      = var.client
  project     = var.project
  environment = var.environment

  sg_config = local.sg_config_transformed

  depends_on = [module.vpc]
}

############################################################################
# 3. VPC Endpoints Gateway - S3 y DynamoDB
############################################################################
module "vpc_endpoints" {
  source = "github.com/somospragma/cloudops-ref-repo-aws-vpc-endpoint-terraform?ref=v1.0.1"

  providers = {
    aws.project = aws.principal
  }

  client      = var.client
  project     = var.project
  environment = var.environment

  vpc_endpoints = local.vpc_endpoints_transformed

  depends_on = [module.vpc]
}
