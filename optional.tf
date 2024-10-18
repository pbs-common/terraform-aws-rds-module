variable "name" {
  description = "Name of the RDS Module. If null, will default to product."
  default     = null
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  default     = null
  type        = string
}

variable "private_subnets" {
  description = "Private subnets"
  default     = null
  type        = list(string)
}

variable "port" {
  description = "Port for the DB"
  default     = null
  type        = number
}

variable "db_admin_username" {
  description = "Admin username for the DB"
  default     = "admin"
  type        = string
  sensitive   = true
}

variable "db_admin_password" {
  description = "Admin password for the DB"
  default     = null
  type        = string
  sensitive   = true
}

variable "use_prefix" {
  description = "Create bucket with prefix instead of explicit name"
  default     = true
  type        = bool
}

variable "engine" {
  description = "Engine to use for the DB"
  default     = "aurora-mysql"
  type        = string
}

variable "engine_mode" {
  description = "Engine mode of the RDS cluster"
  default     = "provisioned"
  type        = string
  validation {
    condition     = var.engine_mode == "provisioned" || var.engine_mode == "serverless"
    error_message = "This module supports only Aurora provisioned or Serverless v2. Please set engine_mode to 'serverless' for Serverless v2 or 'provisioned' for provisioned mode."
  }
}

variable "engine_version" {
  description = "Engine version of the RDS cluster"
  default     = "14.6" # Use a valid version for Serverless v2
  type        = string
  validation {
    condition     = (var.engine_version >= "13.7" && var.engine_version <= "13.7") || (var.engine_version >= "14" && var.engine_version <= "15")
    error_message = "Ensure the engine version is compatible with Aurora PostgreSQL versions that support Serverless v2 (>= 13.7 or 14.x)."
  }
}

variable "engine_version" {
  description = "Engine version of the RDS cluster. If null, one will be looked up based on preferred versions."
  default     = null
  type        = string
}

variable "engine_preferred_versions" {
  description = "Engine preferred versions of the RDS cluster"
  default     = ["8.0.mysql_aurora.3.02.0"]
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones to be used by this RDS cluster"
  default     = null
  type        = list(string)
  validation {
    condition     = var.availability_zones == null || length(var.availability_zones != null ? var.availability_zones : []) == 3
    error_message = "If you specify the availability zones for this module, you must specify exactly three. See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster#availability_zones."
  }
}


variable "backup_retention_period" {
  description = "Backup retention period"
  default     = 7
  type        = number
}

variable "min_capacity" {
  description = "Minimum capacity for the cluster"
  default     = 0.5
  type        = number
}

variable "max_capacity" {
  description = "Maximum capacity for the cluster"
  default     = 16
  type        = number
}

variable "deletion_protection" {
  description = "Deletion protection"
  default     = true
  type        = bool
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot"
  default     = false
  type        = bool
}

variable "private_hosted_zone" {
  description = "Private hosted zone for account"
  default     = null
  type        = string
}

variable "create_dns" {
  description = "Whether to create a DNS record"
  default     = true
  type        = bool
}

variable "dns_ttl" {
  description = "TTL for DNS record"
  default     = 300
  type        = number
}

variable "instance_class" {
  description = "Instance class"
  default     = "db.serverless"
  type        = string
}

variable "apply_immediately" {
  description = "Apply changes immediately. If false, will apply updates during the next maintenance window."
  default     = false
  type        = bool
}

variable "reader_count" {
  description = "Number of reader instances to provision"
  default     = 1
  type        = number
}

variable "preferred_backup_window" {
  description = "Preferred backup window"
  default     = "04:00-04:30" # UTC, 00:00-00:30 ET
  type        = string
}

variable "preferred_maintenance_window" {
  description = "Preferred maintenance window"
  default     = "sun:05:00-sun:06:00" # UTC, 01:00-02:00 ET
  type        = string
}

variable "use_proxy" {
  description = "Use RDS proxy"
  default     = false
  type        = bool
}

variable "proxy_name" {
  description = "Name of the RDS proxy. If null, will default to `local.name`."
  default     = null
  type        = string
}

variable "proxy_debug_logging" {
  description = "Enable debug logging for RDS proxy"
  default     = false
  type        = bool
}

variable "proxy_engine_family" {
  description = "Engine family for RDS proxy"
  default     = "MYSQL"
  type        = string
  validation {
    condition     = contains(["MYSQL", "POSTGRESQL"], var.proxy_engine_family)
    error_message = "The engine family must be either MYSQL or POSTGRESQL."
  }
}

variable "proxy_idle_client_timeout" {
  description = "Idle client timeout for RDS proxy"
  default     = 1800
  type        = number
}

variable "proxy_require_tls" {
  description = "Require TLS for RDS proxy"
  default     = false
  type        = bool
}

variable "proxy_kms_key_id" {
  description = "KMS key ID for RDS proxy. By default, uses the alias for the account's default KMS key for Secrets Manager."
  default     = "alias/aws/secretsmanager"
  type        = string
}

variable "proxy_username" {
  description = "Username for RDS proxy"
  default     = null
  type        = string
  sensitive   = true
}

variable "proxy_password" {
  description = "Password for RDS proxy"
  default     = null
  type        = string
  sensitive   = true
}

variable "proxy_iam_auth" {
  description = "Enable IAM authentication for RDS proxy"
  default     = "DISABLED"
  type        = string
  validation {
    condition     = contains(["DISABLED", "REQUIRED"], var.proxy_iam_auth)
    error_message = "The IAM authentication setting must be either DISABLED or REQUIRED."
  }
}

variable "egress_cidr_blocks" {
  description = "List of CIDR blocks to assign to the egress rule of the security group. If null, `egress_security_group_ids` must be used."
  default     = ["10.0.0.0/8"]
  type        = list(string)
}

variable "egress_source_sg_id" {
  description = "List of security group ID to assign to the egress rule of the security group. If null, `egress_cidr_blocks` must be used."
  default     = null
  type        = string
}

variable "final_snapshot_identifier" {
  description = "Final snapshot identifier"
  default     = null
  type        = string
}

variable "snapshot_identifier" {
  description = "Snapshot identifier"
  default     = null
  type        = string
}

variable "db_cluster_parameter_group_name" {
  description = "DB cluster parameter group name"
  default     = null
  type        = string
}
