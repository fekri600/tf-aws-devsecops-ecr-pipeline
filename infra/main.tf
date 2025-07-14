module "oidc" {
  source = "./oidc"
  oidc = var.oidc
  policies_path = local.policies  # Pass the path to the policies directory
}


module "ecr" {
  source           = "./ecr"
  project_settings = var.project_settings
  policies_path = local.policies  # Pass the path to the policies directory
}


