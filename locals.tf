locals {
  name       = var.name != null ? var.name : var.product
  proxy_name = var.proxy_name != null ? var.proxy_name : local.name

  cluster_identifier        = var.use_prefix ? null : local.name
  cluster_identifier_prefix = var.use_prefix ? "${local.name}-" : null

  vpc_id              = var.vpc_id != null ? var.vpc_id : data.aws_vpc.vpc[0].id
  private_subnets     = var.private_subnets != null ? var.private_subnets : data.aws_subnets.private_subnets[0].ids
  private_hosted_zone = var.create_dns ? data.aws_route53_zone.private_hosted_zone[0].zone_id : null
  availability_zones  = var.availability_zones != null ? var.availability_zones : slice(data.aws_availability_zones.available[0].names, 0, 3) # We take the slice here because we can only specify 3 AZs

  db_admin_password = var.db_admin_password != null ? var.db_admin_password : random_password.password.result

  proxy_username = var.proxy_username != null ? var.proxy_username : var.db_admin_username
  proxy_password = var.proxy_password != null ? var.proxy_password : local.db_admin_password

  engine_version = var.engine_version != null ? var.engine_version : data.aws_rds_engine_version.engine_version[0].version

  sg_id = var.use_proxy ? aws_security_group.proxy_sg[0].id : aws_security_group.sg.id

  dns_target        = var.use_proxy ? aws_db_proxy.proxy[0].endpoint : aws_rds_cluster.db.endpoint
  reader_dns_target = var.use_proxy ? aws_db_proxy_endpoint.reader[0].endpoint : aws_rds_cluster.db.reader_endpoint

  db_cluster_dns        = var.create_dns ? aws_route53_record.primary[0].fqdn : local.dns_target
  db_cluster_reader_dns = var.create_dns ? aws_route53_record.reader[0].fqdn : local.reader_dns_target

  creator = "terraform"

  tags = merge(
    var.tags,
    {
      Name                                      = local.name
      "${var.organization}:billing:product"     = var.product
      "${var.organization}:billing:environment" = var.environment
      creator                                   = local.creator
      repo                                      = var.repo
    }
  )
}
