# PBS TF RDS Module

## Installation

### Using the Repo Source

Use this URL for the source of the module. See the usage examples below for more details.

```hcl
github.com/pbs/terraform-aws-rds-module?ref=x.y.z
```

### Alternative Installation Methods

More information can be found on these install methods and more in [the documentation here](./docs/general/install).

## Usage

This module provisions a basic RDS cluster.

When the RDS cluster is created, a sensitive output variable `db_admin_password` is present that can be used to connect to the database as the user specified by `db_admin_user` (it's `admin` by default). It is highly recommended that this password be rotated out as quickly as possible after provisioning the database, and that the value is not stored or used afterwards. Use this admin user to create a new database user with restricted permissions to a single database for application connectivity.

This module also assumes that connections are established through a private DNS record stored in the output variable `db_cluster_dns`. This makes it so that adjustments to the database can be made in a fashion that is transparent to application configurations. If you would like to disable this functionality, pass in `false` to the `create_dns` variable.

Using the `use_proxy` variable will also provision an RDS proxy that can be used to proxy connections to the database. This is useful for applications that might spawn many short lived connections to the database. The proxy will pool those connections, protecting the cluster.

Integrate this module like so:

```hcl
module "rds" {
  source = "github.com/pbs/terraform-aws-rds-module?ref=x.y.z"

  # Required Parameters
  private_hosted_zone = "example.local"

  # Tagging Parameters
  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo

  # Optional Parameters
}
```

## Adding This Version of the Module

If this repo is added as a subtree, then the version of the module should be close to the version shown here:

`x.y.z`

Note, however that subtrees can be altered as desired within repositories.

Further documentation on usage can be found [here](./docs).

Below is automatically generated documentation on this Terraform module using [terraform-docs][terraform-docs]

---

[terraform-docs]: https://github.com/terraform-docs/terraform-docs

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.12.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.16.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_proxy.proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy) | resource |
| [aws_db_proxy_default_target_group.default_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy_default_target_group) | resource |
| [aws_db_proxy_endpoint.reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy_endpoint) | resource |
| [aws_db_proxy_target.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy_target) | resource |
| [aws_db_subnet_group.subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_iam_role.proxy_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.proxy_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_rds_cluster.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_instance.writer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_route53_record.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_secretsmanager_secret.proxy_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.proxy_secret_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.proxy_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.proxy_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.proxy_to_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_default_tags.common_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |
| [aws_iam_policy_document.proxy_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_kms_key.proxy_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_rds_engine_version.engine_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/rds_engine_version) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.private_hosted_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_subnets.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (sharedtools, dev, staging, qa, prod) | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | Organization using this module. Used to prefix tags so that they are easily identified as being from your organization | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | Tag used to point to the repo using this module | `string` | n/a | yes |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Apply changes immediately. If false, will apply updates during the next maintenance window. | `bool` | `false` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Availability zones to be used by this RDS cluster | `list(string)` | `null` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Backup retention period | `number` | `7` | no |
| <a name="input_create_dns"></a> [create\_dns](#input\_create\_dns) | Whether to create a DNS record | `bool` | `true` | no |
| <a name="input_db_admin_password"></a> [db\_admin\_password](#input\_db\_admin\_password) | Admin password for the DB | `string` | `null` | no |
| <a name="input_db_admin_username"></a> [db\_admin\_username](#input\_db\_admin\_username) | Admin username for the DB | `string` | `"admin"` | no |
| <a name="input_db_cluster_parameter_group_name"></a> [db\_cluster\_parameter\_group\_name](#input\_db\_cluster\_parameter\_group\_name) | DB cluster parameter group name | `string` | `null` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Deletion protection | `bool` | `true` | no |
| <a name="input_dns_ttl"></a> [dns\_ttl](#input\_dns\_ttl) | TTL for DNS record | `number` | `300` | no |
| <a name="input_egress_cidr_blocks"></a> [egress\_cidr\_blocks](#input\_egress\_cidr\_blocks) | List of CIDR blocks to assign to the egress rule of the security group. If null, `egress_security_group_ids` must be used. | `list(string)` | <pre>[<br>  "10.0.0.0/8"<br>]</pre> | no |
| <a name="input_egress_source_sg_id"></a> [egress\_source\_sg\_id](#input\_egress\_source\_sg\_id) | List of security group ID to assign to the egress rule of the security group. If null, `egress_cidr_blocks` must be used. | `string` | `null` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | Engine to use for the DB | `string` | `"aurora-mysql"` | no |
| <a name="input_engine_mode"></a> [engine\_mode](#input\_engine\_mode) | Engine mode of the RDS cluster | `string` | `"provisioned"` | no |
| <a name="input_engine_preferred_versions"></a> [engine\_preferred\_versions](#input\_engine\_preferred\_versions) | Engine preferred versions of the RDS cluster | `list(string)` | <pre>[<br>  "8.0.mysql_aurora.3.02.0"<br>]</pre> | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Engine version of the RDS cluster. If null, one will be looked up based on preferred versions. | `string` | `null` | no |
| <a name="input_final_snapshot_identifier"></a> [final\_snapshot\_identifier](#input\_final\_snapshot\_identifier) | Final snapshot identifier | `string` | `null` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | Instance class | `string` | `"db.serverless"` | no |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | Maximum capacity for the cluster | `number` | `16` | no |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | Minimum capacity for the cluster | `number` | `0.5` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the RDS Module. If null, will default to product. | `string` | `null` | no |
| <a name="input_port"></a> [port](#input\_port) | Port for the DB | `number` | `null` | no |
| <a name="input_preferred_backup_window"></a> [preferred\_backup\_window](#input\_preferred\_backup\_window) | Preferred backup window | `string` | `"04:00-04:30"` | no |
| <a name="input_preferred_maintenance_window"></a> [preferred\_maintenance\_window](#input\_preferred\_maintenance\_window) | Preferred maintenance window | `string` | `"sun:05:00-sun:06:00"` | no |
| <a name="input_private_hosted_zone"></a> [private\_hosted\_zone](#input\_private\_hosted\_zone) | Private hosted zone for account | `string` | `null` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | Private subnets | `list(string)` | `null` | no |
| <a name="input_proxy_debug_logging"></a> [proxy\_debug\_logging](#input\_proxy\_debug\_logging) | Enable debug logging for RDS proxy | `bool` | `false` | no |
| <a name="input_proxy_engine_family"></a> [proxy\_engine\_family](#input\_proxy\_engine\_family) | Engine family for RDS proxy | `string` | `"MYSQL"` | no |
| <a name="input_proxy_iam_auth"></a> [proxy\_iam\_auth](#input\_proxy\_iam\_auth) | Enable IAM authentication for RDS proxy | `string` | `"DISABLED"` | no |
| <a name="input_proxy_idle_client_timeout"></a> [proxy\_idle\_client\_timeout](#input\_proxy\_idle\_client\_timeout) | Idle client timeout for RDS proxy | `number` | `1800` | no |
| <a name="input_proxy_kms_key_id"></a> [proxy\_kms\_key\_id](#input\_proxy\_kms\_key\_id) | KMS key ID for RDS proxy. By default, uses the alias for the account's default KMS key for Secrets Manager. | `string` | `"alias/aws/secretsmanager"` | no |
| <a name="input_proxy_name"></a> [proxy\_name](#input\_proxy\_name) | Name of the RDS proxy. If null, will default to `local.name`. | `string` | `null` | no |
| <a name="input_proxy_password"></a> [proxy\_password](#input\_proxy\_password) | Password for RDS proxy | `string` | `null` | no |
| <a name="input_proxy_require_tls"></a> [proxy\_require\_tls](#input\_proxy\_require\_tls) | Require TLS for RDS proxy | `bool` | `false` | no |
| <a name="input_proxy_username"></a> [proxy\_username](#input\_proxy\_username) | Username for RDS proxy | `string` | `null` | no |
| <a name="input_reader_count"></a> [reader\_count](#input\_reader\_count) | Number of reader instances to provision | `number` | `1` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Skip final snapshot | `bool` | `false` | no |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | Snapshot identifier | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Extra tags | `map(string)` | `{}` | no |
| <a name="input_use_prefix"></a> [use\_prefix](#input\_use\_prefix) | Create bucket with prefix instead of explicit name | `bool` | `true` | no |
| <a name="input_use_proxy"></a> [use\_proxy](#input\_use\_proxy) | Use RDS proxy | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_admin_password"></a> [db\_admin\_password](#output\_db\_admin\_password) | Admin password for DB |
| <a name="output_db_admin_username"></a> [db\_admin\_username](#output\_db\_admin\_username) | Admin username for DB |
| <a name="output_db_cluster_dns"></a> [db\_cluster\_dns](#output\_db\_cluster\_dns) | Private DNS record for the DB Cluster endpoint (if create\_dns is true, otherwise the endpoint itself) |
| <a name="output_db_cluster_reader_dns"></a> [db\_cluster\_reader\_dns](#output\_db\_cluster\_reader\_dns) | Private DNS record for the DB Cluster reader endpoint (if create\_dns is true, otherwise the endpoint itself) |
| <a name="output_name"></a> [name](#output\_name) | Name of the DB |
| <a name="output_sg_id"></a> [sg\_id](#output\_sg\_id) | Security group ID for DB |
