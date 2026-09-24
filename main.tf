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
  }

  tags = local.tags
}
