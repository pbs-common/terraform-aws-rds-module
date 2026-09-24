output "name" {
  description = "Name of the DB"
  value       = aws_rds_cluster.db.id
}

output "db_admin_username" {
  description = "Admin username for DB"
  value       = var.db_admin_username
  sensitive   = true
}

output "db_admin_password" {
  description = "Admin password for DB. Null when the module does not set the master password (`set_master_password = false` or `manage_master_user_password = true`)."
  value       = local.db_admin_password
  sensitive   = true
}

output "master_user_secret_arn" {
  description = "ARN of the Secrets Manager secret RDS manages for the master password. Null unless `manage_master_user_password` is true."
  value       = try(aws_rds_cluster.db.master_user_secret[0].secret_arn, null)
}

output "db_cluster_dns" {
  description = "Private DNS record for the DB Cluster endpoint (if create_dns is true, otherwise the endpoint itself)"
  value       = local.db_cluster_dns
}

output "db_cluster_reader_dns" {
  description = "Private DNS record for the DB Cluster reader endpoint (if create_dns is true, otherwise the endpoint itself)"
  value       = local.db_cluster_reader_dns
}

output "db_admin_dns" {
  description = "DNS endpoint for performing administrative tasks on the database, i.e. the non-proxy writer endpoint for the cluster"
  value       = aws_rds_cluster.db.endpoint
}

output "sg_id" {
  description = "Security group ID for DB. If use_proxy is true, this is the proxy SG, otherwise it's the cluster's security group"
  value       = local.sg_id
}

output "admin_sg_id" {
  description = "The security group id for performing administrative tasks on the database. If use_proxy is false, this is the same as sg_id"
  value       = aws_security_group.sg.id
}

output "cluster_parameter_group_name" {
  value       = local.db_cluster_parameter_group_name
  description = "The name of the cluster parameter group attached to the cluster"
}

output "instance_parameter_group_name" {
  value       = local.db_instance_parameter_group_name
  description = "The name of the instance parameter group attached to the instances"
}

output "parameter_group_family" {
  value       = local.parameter_group_family
  description = "The family type of the parameter groups"
}
