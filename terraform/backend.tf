terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = var.terraform_organization_name

    workspaces {
      name = var.terraform_workspace_name
    }
  }
}
