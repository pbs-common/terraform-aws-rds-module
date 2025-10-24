module "rds" {
  source = "../.."

  create_dns = false

  # Just to make testing easier
  deletion_protection = false
  skip_final_snapshot = true


  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo
  owner        = var.owner
}
