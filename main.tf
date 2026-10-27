resource "aws_rds_cluster" "db" {
  cluster_identifier              = local.cluster_identifier
  cluster_identifier_prefix       = local.cluster_identifier_prefix
  engine                          = var.engine
  engine_mode                     = var.engine_mode
  engine_version                  = local.engine_version
  availability_zones              = local.availability_zones
  master_username                 = var.db_admin_username
  master_password                 = local.db_admin_password
  backup_retention_period         = var.backup_retention_period
  vpc_security_group_ids          = concat([aws_security_group.sg.id], var.extra_security_group_ids)
  db_subnet_group_name            = aws_db_subnet_group.subnet_group.id
  apply_immediately               = var.apply_immediately
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  port                            = var.port
  final_snapshot_identifier       = var.final_snapshot_identifier
  snapshot_identifier             = var.snapshot_identifier
  db_cluster_parameter_group_name = local.db_cluster_parameter_group_name
  storage_encrypted               = var.storage_encrypted
  kms_key_id                      = var.kms_key_id
  copy_tags_to_snapshot           = var.copy_tags_to_snapshot
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  database_insights_mode                = var.database_insights_mode
  performance_insights_enabled          = var.cluster_performance_insights_enabled
  performance_insights_kms_key_id       = local.cluster_performance_insights_kms_key_id
  performance_insights_retention_period = local.cluster_performance_insights_retention_period

  deletion_protection = var.deletion_protection
  skip_final_snapshot = var.skip_final_snapshot

  dynamic "serverlessv2_scaling_configuration" {
    for_each = local.serverless_scaling_enabled ? [1] : []
    content {
      min_capacity             = var.min_capacity
      max_capacity             = var.max_capacity
      seconds_until_auto_pause = var.min_capacity == 0 ? var.seconds_until_auto_pause : null
    }
  }

  # Ignoring these because they trigger nonsense updates. master_password is only set at creation:
  # an imported cluster has no password in state, so managing it would rotate the live one.
  lifecycle {
    ignore_changes = [
      snapshot_identifier,
      master_password,
    ]

    precondition {
      condition     = var.database_insights_mode != "advanced" || (var.cluster_performance_insights_enabled == true && coalesce(var.performance_insights_retention_period, 0) >= 465)
      error_message = "database_insights_mode = \"advanced\" requires cluster_performance_insights_enabled = true and performance_insights_retention_period of at least 465."
    }
  }

  tags = local.tags
}
