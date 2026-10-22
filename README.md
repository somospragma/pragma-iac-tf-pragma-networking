# pragma-iac-tf-pragma-networking

Infraestructura como código (Terraform) de la **capa de red base** del workshop Perú (cliente **pragma**, proyecto **transfers**) en AWS, ambiente **dev**. Despliega la VPC, subnets, NAT Gateway y VPC Endpoints sobre los que corren el transversal y la capa de aplicación (core).

Modo **standalone**: sin Transit Gateway ni Route53 Private Hosted Zone compartidos.

Usa los **módulos de referencia de somospragma** (GitHub público).

---

## Arquitectura

```
                                    Internet
                                       │
                                       ▼
                            ┌─────────────────────┐
                            │  Internet Gateway   │
                            │ pragma-transfers-   │
                            │      dev-igw        │
                            └──────────┬──────────┘
                                       │
                    ┌──────────────────┴────────────────────┐
                    │   VPC: pragma-transfers-dev-vpc       │
                    │        CIDR: 10.30.0.0/22             │
                    │                                       │
    ┌─────────────────────────────┬────────────────┬──────────────────┐
    │                             │                │                  │
    ▼                             ▼                ▼                  ▼
┌──────────┐   ┌─────────┐    ┌───────────┐    ┌───────────┐   ┌────────────┐
│ Service  │   │ Public  │    │  Private  │    │ Database  │   │    NAT     │
│ Subnets  │   │ Subnets │    │  Subnets  │    │  Subnets  │   │  Gateway   │
│ (2 AZ)   │   │ (2 AZ)  │    │  (2 AZ)   │    │  (2 AZ)   │   │ (regional) │
│ /24 x2   │   │ /26 x2  │    │  /26 x2   │    │  /26 x2   │   └──────┬─────┘
└──────────┘   └─────────┘    └─────┬─────┘    └───────────┘          │
                                    │                                 │
                                    └─────────────────────────────────┘
                                              egress a Internet

                    ┌──────────────────────────────────────────┐
                    │  VPC Endpoints Gateway (sin costo NAT)   │
                    │  S3        → private/service/database    │
                    │  DynamoDB  → private/service/database    │
                    └──────────────────────────────────────────┘
```

> Este repo no despliega security groups con reglas (`sg_config = {}`, módulo incluido pero vacío) ni compute. Esos recursos viven en las capas de transversal y de aplicación.

---

## Recursos Desplegados

| Recurso | Módulo | Versión | Descripción |
|---------|--------|---------|-------------|
| VPC | `cloudops-ref-repo-aws-vpc-terraform` | `v1.0.4` | VPC + 4 tipos de subnet x 2 AZs + IGW + NAT regional |
| Security Groups | `cloudops-ref-repo-aws-sg-terraform` | `v1.0.2` | Módulo incluido, `sg_config = {}` (sin reglas aún) |
| VPC Endpoints | `cloudops-ref-repo-aws-vpc-endpoint-terraform` | `v1.0.1` | Gateway endpoints: S3 y DynamoDB |

Fuente: [somospragma](https://github.com/somospragma) (GitHub público, módulos `cloudops-ref-repo-aws-*-terraform`).

---

## Estructura del Proyecto

```
pragma-iac-tf-pragma-networking/
├── main.tf                 # Módulos: vpc → security_groups → vpc_endpoints
├── locals.tf               # subnet_config_transformed, inyección de vpc_id en SG/endpoints
├── variables.tf            # Declaración de todas las variables tipadas
├── outputs.tf              # vpc_id, subnet_ids, route_table_ids, nat_gateway_id, vpc_endpoint_ids
├── providers.tf            # Provider AWS con assume_role + backend S3 vacío
├── data.tf                 # Sin data sources (modo standalone)
├── azure-pipelines.yaml    # Extiende el template corporativo de IaC
└── environments/
    └── dev/
        ├── terraform.tfvars   # client=pragma, project=transfers
        └── .env.yaml          # Variable group + ENVIRONMENT=dev
```

---

## Direccionamiento DEV (esquema /22)

```
Service:   10.30.0.0/24,   10.30.1.0/24    (us-east-1a, us-east-1b)
Public:    10.30.2.0/26,   10.30.2.64/26   (us-east-1a, us-east-1b)
Private:   10.30.2.128/26, 10.30.2.192/26  (us-east-1a, us-east-1b)
Database:  10.30.3.0/26,   10.30.3.64/26   (us-east-1a, us-east-1b)
```

---

## Nomenclatura

Patrón: `{client}-{project}-{environment}-{type}-{key}`

Con `client=pragma`, `project=transfers`, `environment=dev`:

| Recurso | Nombre AWS resultante |
|---------|------------------------|
| VPC | `pragma-transfers-dev-vpc` |
| Internet Gateway | `pragma-transfers-dev-igw` |
| NAT Gateway (regional) | `pragma-transfers-dev-nat-regional` |
| Subnets | `pragma-transfers-dev-subnet-{public\|private\|service\|database}-{1\|2}` |

---

## Outputs

| Output | Descripción |
|--------|--------------|
| `vpc_id` | ID de la VPC |
| `subnet_ids` | Mapa de IDs de subnets por tipo |
| `route_table_ids` | Mapa de IDs de route tables por tipo |
| `nat_gateway_id` | ID del NAT Gateway (regional) |
| `security_group_ids` | Mapa de IDs de Security Groups (vacío, `sg_config = {}`) |
| `vpc_endpoint_ids` | Mapa de IDs de los VPC Endpoints Gateway (S3, DynamoDB) |

Estos outputs los consumen las capas de transversal/aplicación.

---

## Validar en local

```bash
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```
