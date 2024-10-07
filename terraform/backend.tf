terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "<YOUR_ORGANIZATION_NAME>" # Replace with your organization name

    workspaces {
      name = "<YOUR_WORKSPACE_NAME>" # Replace with your workspace name
    }
  }
}
