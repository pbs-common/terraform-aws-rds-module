module "rds" {
  source = "../.."

  private_hosted_zone = var.private_hosted_zone

  instance_class = "db.t3.medium"

  # Just to make testing easier
  deletion_protection = false
  skip_final_snapshot = true

  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo
  owner        = var.owner
}
