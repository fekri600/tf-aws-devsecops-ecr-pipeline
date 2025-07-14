variable "oidc" {
  description = "OIDC configuration settings"
  type = object({
    oidc_url             = string
    oidc_client_id_list  = list(string)
    oidc_thumbprint_list = list(string)
    iam_role_name        = string
    iam_policy_name      = string
  })
}

variable "policies_path" {
  type = string
}