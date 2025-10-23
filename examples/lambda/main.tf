module "lambda" {
  source = "github.com/pbs/terraform-aws-lambda-module?ref=2.0.0"

  handler  = "index.handler"
  filename = "./artifacts/handler.zip"
  runtime  = "python3.13"

  architectures = ["arm64"]

  add_vpc_config = true

  environment_vars = {
    "MYSQL_HOST"          = module.rds.db_cluster_dns
    "MYSQL_READONLY_HOST" = module.rds.db_cluster_reader_dns

    # These have to be non-sensitive because the Lambda module utilizes a for_each this variable.
    "MYSQL_USER"     = nonsensitive(module.rds.db_admin_username)
    "MYSQL_PASSWORD" = nonsensitive(module.rds.db_admin_password)
  }

  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo
  owner        = var.owner
}

module "rds" {
  source = "../.."

  private_hosted_zone = var.private_hosted_zone

  use_proxy = true

  # Just to make testing easier
  deletion_protection = false
  skip_final_snapshot = true

  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo
  owner        = var.owner
}

resource "aws_security_group_rule" "mysql_ingress_rule" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.lambda.sg
  security_group_id        = module.rds.sg_id
}
