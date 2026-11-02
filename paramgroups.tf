resource "aws_rds_cluster_parameter_group" "this" {
  count       = var.create_db_cluster_parameter_group ? 1 : 0
  name        = var.db_cluster_parameter_group_resource_name != null ? var.db_cluster_parameter_group_resource_name : "${local.name}-${local.parameter_group_name_suffix}"
  family      = local.parameter_group_family
  description = var.db_cluster_parameter_group_description != null ? var.db_cluster_parameter_group_description : "RDS Cluster parameter group for ${local.name}"

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
  count       = var.create_db_instance_parameter_group ? 1 : 0
  name        = var.db_instance_parameter_group_resource_name != null ? var.db_instance_parameter_group_resource_name : "${local.name}-${local.parameter_group_name_suffix}"
  description = var.db_instance_parameter_group_description != null ? var.db_instance_parameter_group_description : "RDS Instance parameter group for ${local.name}"
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

# The parameter groups gained a count, so existing state moves to the first instance
moved {
  from = aws_rds_cluster_parameter_group.this
  to   = aws_rds_cluster_parameter_group.this[0]
}

moved {
  from = aws_db_parameter_group.this
  to   = aws_db_parameter_group.this[0]
}
