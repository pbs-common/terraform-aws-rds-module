resource "aws_rds_cluster" "db" {
  cluster_identifier           = local.cluster_identifier
  cluster_identifier_prefix    = local.cluster_identifier_prefix
  engine                       = var.engine
  engine_mode                  = var.engine_mode
  engine_version               = local.engine_version
  availability_zones           = local.availability_zones
  master_username              = var.db_admin_username
  master_password              = local.db_admin_password
  backup_retention_period      = var.backup_retention_period
  vpc_security_group_ids       = [aws_security_group.sg.id]
  db_subnet_group_name         = aws_db_subnet_group.subnet_group.id
  apply_immediately            = var.apply_immediately
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window
  port                         = var.port
  final_snapshot_identifier    = var.final_snapshot_identifier
  snapshot_identifier          = var.snapshot_identifier

  deletion_protection = var.deletion_protection
  skip_final_snapshot = var.skip_final_snapshot

  serverlessv2_scaling_configuration {
    min_capacity = var.min_capacity
    max_capacity = var.max_capacity
  }

  # Ignoring these because they trigger nonsense updates
  lifecycle {
    ignore_changes = [
      snapshot_identifier,
    ]
  }

  tags = local.tags
}
