resource "aws_rds_cluster_parameter_group" "this" {
  name        = "${local.name}-${local.parameter_group_family}"
  family      = local.parameter_group_family
  description = "RDS Cluster parameter group for ${local.name}"

  dynamic "parameter" {
    for_each = var.db_cluster_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_parameter_group" "this" {
  name        = "${local.name}-${local.parameter_group_family}"
  description = "RDS Instance parameter group for ${local.name}"
  family      = local.parameter_group_family

  dynamic "parameter" {
    for_each = var.db_instance_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}
