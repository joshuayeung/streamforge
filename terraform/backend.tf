terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "Pythogenius" # Replace with your organization name

    workspaces {
      name = "streamforge" # Replace with your workspace name
    }
  }
}
