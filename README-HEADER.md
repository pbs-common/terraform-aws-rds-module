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

### Instances

By default the module creates one writer and one reader. `reader_count` controls the readers; `create_writer = false` drops the writer, for a cluster whose instances are managed elsewhere or a Serverless v2 cluster that has none of its own.

Serverless v2 scaling normally follows `instance_class == "db.serverless"`, which is correct whenever the module creates the instances. When it does not — `create_writer = false` with `reader_count = 0` — say so directly with `serverless_scaling_enabled`. See [the no-instances example](/examples/no-instances).

Performance Insights is off unless asked for: set `performance_insights_enabled`, optionally with `performance_insights_kms_key_id` and `performance_insights_retention_period` (7, 731, or a multiple of 31). Leaving `performance_insights_enabled` null leaves the setting unmanaged, so existing instances keep what they have.

### Encryption

`storage_encrypted` is on by default using the AWS managed `aws/rds` key. Pass `kms_key_id` to use a customer managed key.

> :warning: `kms_key_id` forces replacement. A cluster already encrypted with a customer managed key must be given that key's ARN for Terraform to manage the setting — omitting it leaves the key in place but unmanaged, and any cluster created fresh without it silently falls back to `aws/rds`.

### Logging

`enabled_cloudwatch_logs_exports` selects the log types sent to CloudWatch Logs — `audit`, `error`, `general`, `slowquery` for `aurora-mysql`, `postgresql` for `aurora-postgresql`.

> :warning: This attribute is not computed, so leaving it null **removes** exports from a cluster that already has them. A cluster already exporting logs must list them here, or its log exports will be switched off.

### Master password

The master password is set once, when the cluster is created — from `db_admin_password`, or a generated password when that is null — and exposed as the `db_admin_password` output. Changes to it are ignored afterwards, so neither changing `db_admin_password` nor importing an existing cluster rotates the live password.

> :warning: For an imported cluster, and for any cluster whose password was rotated outside Terraform, the `db_admin_password` output is not the live password. Rotate the master password with the AWS console or CLI.

### Adopting an existing cluster

An existing cluster often has settings the module would otherwise replace:

- `db_instance_parameter_group_name` attaches an existing instance parameter group (e.g. `default.aurora-postgresql16`) instead of the module's own. The module still creates its group, unattached. `db_cluster_parameter_group_name` does the same for the cluster parameter group.
- `extra_security_group_ids` attaches more security groups alongside the module's. A cluster that already has other groups must list them here, or they are detached.

### Availability zones

`availability_zones` is null by default, which leaves the zones unmanaged: AWS places a new cluster itself, and an existing cluster keeps the zones it already has.

> :warning: The attribute forces replacement. Only set it when creating a cluster whose zones you need to pin, and never to a set that differs from a live cluster's.

## Adding This Version of the Module

If this repo is added as a subtree, then the version of the module should be close to the version shown here:

`x.y.z`

Note, however that subtrees can be altered as desired within repositories.

Further documentation on usage can be found [here](./docs).

Below is automatically generated documentation on this Terraform module using [terraform-docs][terraform-docs]

---

[terraform-docs]: https://github.com/terraform-docs/terraform-docs
