locals {
  governance_prefix = "${var.client}-${var.project}-${var.environment}"

  # Standalone: NAT propio controlado por var.vpc_create_nat
  create_nat = var.vpc_create_nat

  # Config de subnets: 4 tipos x 2 AZ.
  # include_nat: private y service salen a Internet por el NAT; public y database no.
  subnet_config_transformed = {
    public-subnet = {
      public      = true
      include_nat = false
      subnets = [
        {
          cidr_block        = var.public_subnet_1_cidr_block
          availability_zone = var.public_subnet_1_availability_zone
        },
        {
          cidr_block        = var.public_subnet_2_cidr_block
          availability_zone = var.public_subnet_2_availability_zone
        }
      ]
      custom_routes = []
    }
    private-subnet = {
      public      = false
      include_nat = local.create_nat
      subnets = [
        {
          cidr_block        = var.private_subnet_1_cidr_block
          availability_zone = var.private_subnet_1_availability_zone
        },
        {
          cidr_block        = var.private_subnet_2_cidr_block
          availability_zone = var.private_subnet_2_availability_zone
        }
      ]
      custom_routes = []
    }
    service-subnet = {
      public      = false
      include_nat = local.create_nat
      subnets = [
        {
          cidr_block        = var.service_subnet_1_cidr_block
          availability_zone = var.service_subnet_1_availability_zone
        },
        {
          cidr_block        = var.service_subnet_2_cidr_block
          availability_zone = var.service_subnet_2_availability_zone
        }
      ]
      custom_routes = []
    }
    database-subnet = {
      public      = false
      include_nat = false
      subnets = [
        {
          cidr_block        = var.database_subnet_1_cidr_block
          availability_zone = var.database_subnet_1_availability_zone
        },
        {
          cidr_block        = var.database_subnet_2_cidr_block
          availability_zone = var.database_subnet_2_availability_zone
        }
      ]
      custom_routes = []
    }
  }

  # PC-IAC-026: Patrón de Transformación en Root
  # Flujo: terraform.tfvars -> variables.tf -> locals.tf -> main.tf
  # Inyecta el vpc_id dinámico del módulo VPC en los Gateway Endpoints (S3, DynamoDB)
  vpc_endpoints_transformed = {
    for key, config in var.vpc_endpoints_config : key => {
      vpc_id              = module.vpc.vpc_id
      service_name        = config.service_name
      vpc_endpoint_type   = "Gateway"
      private_dns_enabled = false
      security_group_ids  = []
      subnet_ids          = []
      route_table_ids = [
        module.vpc.route_table_ids["private-subnet"],
        module.vpc.route_table_ids["service-subnet"],
        module.vpc.route_table_ids["database-subnet"],
      ]
    }
  }

  # Inyecta el vpc_id dinámico del módulo VPC en los Security Groups
  sg_config_transformed = {
    for key, config in var.sg_config :
    key => merge(config, {
      vpc_id = length(config.vpc_id) > 0 ? config.vpc_id : module.vpc.vpc_id
    })
  }
}
