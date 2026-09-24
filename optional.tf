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
  default     = "root"
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
  default     = "aurora-postgresql"
  type        = string
}

variable "engine_mode" {
  description = "Engine mode of the RDS cluster"
  default     = "provisioned"
  type        = string
  validation {
    condition     = (var.engine_mode == "provisioned" || var.engine_mode == "serverless")
    error_message = "This module supports only Aurora provisioned or Serverless v2. Please set engine_mode to 'serverless' for Serverless v2 or 'provisioned' for provisioned mode."
  }
}

variable "engine_version" {
  description = "Engine version of the RDS cluster"
  default     = "17.5" # Use a valid version for Serverless v2
  type        = string

  validation {
    condition = (
      can(regex("^(1[4-9]|2[0-9])\\..*$", var.engine_version))  # PostgreSQL
      || can(regex("^8.*.mysql_aurora.*$", var.engine_version)) # Aurora MySQL
      || can(regex("^8.*$", var.engine_version))                # MySQL 8
      || can(regex("^5.7$", var.engine_version))                # MySQL 5.7
    )
    error_message = "Ensure the engine version is compatible with the selected engine type. PostgreSQL versions must be >= 14.0 or between 14.x-19.x. For MySQL, please provide a valid engine version."
  }
}

variable "engine_preferred_versions" {
  description = "Engine preferred versions of the RDS cluster"
  default     = ["17.5"]
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones to be used by this RDS cluster. When null the zones are left unmanaged: AWS places a new cluster itself, and an existing cluster keeps the zones it already has. Setting this on a cluster that already exists in different zones replaces it, so leave it null unless you are creating a cluster and need to pin its zones."
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
  default     = 8
  type        = number
}

variable "seconds_until_auto_pause" {
  description = "(Optional) Time, in seconds, before an Aurora DB cluster in provisioned DB engine mode is paused. Valid values are 300 through 86400"
  default     = 300
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
  description = "Password for RDS proxy. Defaults to the master password, so it is required when the module does not set one (`set_master_password = false` or `manage_master_user_password = true`)."
  default     = null
  type        = string
  sensitive   = true
  validation {
    condition     = !var.use_proxy || var.proxy_password != null || (var.set_master_password && !var.manage_master_user_password)
    error_message = "proxy_password is required with use_proxy when the module does not set the master password."
  }
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

variable "db_cluster_parameter_group_description" {
  description = "Description for the RDS cluster parameter group. Defaults to a generated value."
  default     = null
  type        = string
}

variable "db_instance_parameter_group_description" {
  description = "Description for the RDS instance parameter group. Defaults to a generated value."
  default     = null
  type        = string
}

variable "db_cluster_parameter_group_resource_name" {
  description = "Name of the aws_rds_cluster_parameter_group resource. Defaults to a generated value."
  default     = null
  type        = string
}

variable "db_instance_parameter_group_resource_name" {
  description = "Name of the aws_db_parameter_group resource. Defaults to a generated value."
  default     = null
  type        = string
}

variable "writer_identifier" {
  description = "Explicit identifier for the writer instance. If null, defaults to a generated value."
  default     = null
  type        = string
}

variable "reader_identifier_prefix" {
  description = "Prefix for reader instance identifiers. Reader names become prefix+(index+1). If null, defaults to a generated pattern."
  default     = null
  type        = string
}

variable "reader_identifier" {
  description = "Exact identifier for the reader instance. Overrides reader_identifier_prefix. Use to pin an existing AWS resource name."
  default     = null
  type        = string
}

variable "auto_minor_version_upgrade" {
  description = "Whether to enable auto minor version upgrade for DB instances."
  default     = true
  type        = bool
}

variable "instance_copy_tags_to_snapshot" {
  description = "Whether to copy tags to snapshots for DB instances."
  default     = true
  type        = bool
}

variable "subnet_group_name" {
  description = "Explicit name for the DB subnet group. If set, overrides name_prefix."
  default     = null
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules to create on the DB security group. Each rule supports: description, from_port, to_port, protocol, cidr_blocks (list), source_security_group_id."
  type = list(object({
    description              = optional(string, "")
    from_port                = number
    to_port                  = number
    protocol                 = optional(string, "tcp")
    cidr_blocks              = optional(list(string), [])
    source_security_group_id = optional(string, null)
  }))
  default = []
}

variable "sg_description" {
  description = "Description for the DB security group. Defaults to a generated value."
  default     = null
  type        = string
}

variable "sg_name" {
  description = "Explicit name for the DB security group. If set, overrides name_prefix."
  default     = null
  type        = string
}

variable "db_cluster_parameters" {
  type        = map(any)
  description = "Optional key-value map of parameters to override for the cluster parameter group"
  default     = {}
}

variable "db_instance_parameters" {
  type        = map(any)
  description = "Optional key-value map of parameters to override for the instance parameter group"
  default     = {}
}

variable "storage_encrypted" {
  description = "Whether to enable storage encryption for the RDS cluster"
  default     = true
  type        = bool
}

variable "copy_tags_to_snapshot" {
  description = "Whether to copy tags to snapshots"
  default     = true
  type        = bool
}


variable "autoscaling_enabled" {
  description = "Whether to enable Application Auto Scaling for RDS reader replicas."
  default     = false
  type        = bool
}

variable "autoscaling_min_capacity" {
  description = "Minimum number of reader replicas for autoscaling."
  default     = 1
  type        = number
}

variable "autoscaling_max_capacity" {
  description = "Maximum number of reader replicas for autoscaling."
  default     = 2
  type        = number
}

variable "autoscaling_metric_type" {
  description = "Predefined metric to scale on. Valid values: \"cpu\" (RDSReaderAverageCPUUtilization) or \"connections\" (RDSReaderAverageDatabaseConnectionsUtilization)."
  default     = "cpu"
  type        = string
  validation {
    condition     = contains(["cpu", "connections"], var.autoscaling_metric_type)
    error_message = "autoscaling_metric_type must be \"cpu\" or \"connections\"."
  }
}

variable "autoscaling_target_value" {
  description = "Target value for the autoscaling metric. For \"cpu\", this is a percentage (e.g. 50). For \"connections\", this is a percentage of max connections (e.g. 70)."
  default     = 50
  type        = number
}

variable "autoscaling_scale_in_cooldown" {
  description = "Cooldown period in seconds before allowing a scale-in activity."
  default     = 600
  type        = number
}

variable "autoscaling_scale_out_cooldown" {
  description = "Cooldown period in seconds before allowing a scale-out activity."
  default     = 60
  type        = number
}

variable "kms_key_id" {
  description = "(optional) ARN of the KMS key used to encrypt the cluster's storage. When null the cluster uses the AWS managed `aws/rds` key. Changing this on an existing cluster replaces it, so a cluster already encrypted with a customer managed key must be given that key's ARN here for Terraform to manage the setting rather than leave it unmanaged."
  default     = null
  type        = string
}

variable "enabled_cloudwatch_logs_exports" {
  description = "(optional) Log types to export to CloudWatch Logs. For `aurora-mysql`: audit, error, general, slowquery. For `aurora-postgresql`: postgresql. When null no exports are configured — note that this removes any exports an existing cluster has, so a cluster already exporting logs must list them here."
  default     = null
  type        = list(string)
  validation {
    condition     = var.enabled_cloudwatch_logs_exports == null || alltrue([for t in coalesce(var.enabled_cloudwatch_logs_exports, []) : contains(["audit", "error", "general", "slowquery", "postgresql", "iam-db-auth-error", "instance"], t)])
    error_message = "Each enabled_cloudwatch_logs_exports entry must be one of [audit, error, general, slowquery, postgresql, iam-db-auth-error, instance]."
  }
}

variable "create_writer" {
  description = "(optional) Create a writer instance in the cluster. Set to false to manage a cluster whose instances are managed elsewhere, or an Aurora Serverless v2 cluster that has no instances of its own. A cluster with no writer and `reader_count = 0` has no instances and cannot serve traffic."
  default     = true
  type        = bool
}

variable "serverless_scaling_enabled" {
  description = "(optional) Configure Serverless v2 scaling on the cluster. When null this follows `instance_class == \"db.serverless\"`, which is the right answer whenever the module creates the cluster's instances. Set it explicitly when it is not — a cluster with `create_writer = false` still needs a scaling configuration if its instances are serverless."
  default     = null
  type        = bool
}

variable "performance_insights_enabled" {
  description = "(optional) Enable Performance Insights on the cluster's instances. When null the setting is left unmanaged, so instances keep whatever they already have and new ones take the AWS default."
  default     = null
  type        = bool
}

variable "performance_insights_kms_key_id" {
  description = "(optional) ARN of the KMS key used to encrypt Performance Insights data. Only used when `performance_insights_enabled` is true."
  default     = null
  type        = string
}

variable "performance_insights_retention_period" {
  description = "(optional) Days to retain Performance Insights data. Valid values are 7, 731, or any multiple of 31 up to 731. Only used when `performance_insights_enabled` is true."
  default     = null
  type        = number
  validation {
    condition     = var.performance_insights_retention_period == null || contains([7, 731], coalesce(var.performance_insights_retention_period, 7)) || coalesce(var.performance_insights_retention_period, 7) % 31 == 0
    error_message = "The performance_insights_retention_period must be 7, 731, or a multiple of 31."
  }
}

variable "set_master_password" {
  description = "(optional) Set the cluster's master password, from `db_admin_password` or else a generated one. Set to false when adopting an existing cluster: the module then leaves `master_password` unmanaged, so the live password is not rotated. A cluster created with this false and `manage_master_user_password` false has no password and RDS rejects it."
  default     = true
  type        = bool
}

variable "manage_master_user_password" {
  description = "(optional) Let RDS generate the master password and keep it in Secrets Manager. The module then sets no password of its own, and `db_admin_password` must be null. Turning this on for an existing cluster replaces its password with the managed one."
  default     = false
  type        = bool
  validation {
    condition     = !var.manage_master_user_password || var.db_admin_password == null
    error_message = "db_admin_password must be null when manage_master_user_password is true."
  }
}

variable "master_user_secret_kms_key_id" {
  description = "(optional) KMS key ID, ARN, or alias used to encrypt the RDS-managed master password secret. When null the `aws/secretsmanager` key is used. Only used when `manage_master_user_password` is true."
  default     = null
  type        = string
}

variable "db_instance_parameter_group_name" {
  description = "(optional) Name of an existing DB parameter group to attach to the instances instead of the one the module creates, e.g. `default.aurora-postgresql16`. The module's own group is still created, but left unattached."
  default     = null
  type        = string
}

variable "extra_security_group_ids" {
  description = "(optional) Additional security group IDs to attach to the cluster alongside the one the module creates. A cluster that already has other groups attached must list them here, or they are detached."
  default     = []
  type        = list(string)
  validation {
    condition     = alltrue([for id in var.extra_security_group_ids : can(regex("^sg-[0-9a-f]+$", id))])
    error_message = "Each extra_security_group_ids entry must be a security group ID (sg-...)."
  }
}
