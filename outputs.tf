######################################################################
# VPC Outputs
######################################################################
output "vpc_id" {
  description = "ID de la VPC de pragma-transfers networking"
  value       = module.vpc.vpc_id
}

output "subnet_ids" {
  description = "Mapa de IDs de subnets por tipo (public-subnet, private-subnet, service-subnet, database-subnet)"
  value       = module.vpc.subnet_ids
}

output "route_table_ids" {
  description = "Mapa de IDs de route tables por tipo"
  value       = module.vpc.route_table_ids
}

output "nat_gateway_id" {
  description = "ID del NAT Gateway (regional)"
  value       = module.vpc.nat_gateway_id
}

######################################################################
# Security Groups Outputs
######################################################################
output "security_group_ids" {
  description = "Mapa de IDs de Security Groups creados"
  value       = module.security_groups.sg_ids
}

######################################################################
# VPC Endpoints Gateway Outputs
######################################################################
output "vpc_endpoint_ids" {
  description = "Mapa de IDs de los VPC Endpoints Gateway (S3, DynamoDB)"
  value       = module.vpc_endpoints.vpc_endpoint_ids
}
