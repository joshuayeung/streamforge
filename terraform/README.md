# Terraform Setup

This section outlines how we use Terraform within our GitHub Actions to manage infrastructure and automatically apply changes.

## Prerequisites

1. **Terraform Cloud**: We use Terraform Cloud to manage our Terraform state and run apply operations. You'll need to configure the organization, workspace, and secrets accordingly.
   
2. **GitHub Actions**: Our CI/CD pipeline is set up to trigger Terraform apply whenever there are changes to the infrastructure code under the `terraform/` folder.

## Steps

### 1. Configure Terraform Cloud

Make sure you have the following set up in Terraform Cloud:

- **Organization**: Your Terraform Cloud organization.
- **Workspace**: A dedicated workspace where Terraform will manage and apply the infrastructure.

### 2. GitHub Secrets Setup

We store important information like API tokens and environment details in GitHub Secrets. You need to add the following secrets in your repository’s settings:

- **TERRAFORM_CLOUD_API_TOKEN**: Personal access token (PAT) for accessing Terraform Cloud.
- **TERRAFORM_ORG**: Your Terraform Cloud organization name.
- **TERRAFORM_WORKSPACE**: The workspace name in Terraform Cloud.
- **PAT_FOR_SECRETS**: A Personal Access Token (PAT) with permissions to update GitHub secrets, required to store Terraform outputs.

### 3. GitHub Actions Configuration

Our GitHub Action will handle Terraform workflows and store necessary outputs (e.g., VPC ID, Subnet IDs, S3 Bucket) in GitHub secrets for future use. Here’s a breakdown of the steps in the pipeline:

- **Upload Configuration**: Uploads the Terraform code to the specified workspace in Terraform Cloud.
- **Apply Terraform Run**: Executes the Terraform apply to manage infrastructure.
- **Store Terraform Outputs**: Fetches the Terraform outputs (like `PRIVATE_SUBNET_1`, `PRIVATE_SUBNET_2`, `S3_BUCKET_NAME`, `VPC_ID`) and stores them in GitHub Secrets.

### 4. Environment Variables

The following secrets are used during the Terraform apply process and are set in GitHub Actions:

- **TF_CLOUD_ORGANIZATION**: Set this to your Terraform Cloud organization name.
- **TF_API_TOKEN**: The Terraform Cloud API token for authentication.
- **TF_WORKSPACE**: Your workspace name where Terraform manages the infrastructure.

### 5. Personal Access Token (PAT)

To store Terraform outputs as GitHub Secrets, you need to generate a **Personal Access Token (PAT)** with the following scopes:

- `repo`: Full control of private repositories.
- `admin:repo_hook`: Write access to repository hooks and services.
- `workflow`: Update GitHub Actions workflows.

Add this token as a GitHub secret with the name `PAT_FOR_SECRETS`.

### Running Terraform Locally

To run Terraform locally for testing purposes while still using Terraform Cloud as the backend for state management, follow these steps:

#### Prerequisites

1. **Install Terraform CLI**: Ensure you have the latest version of the [Terraform CLI](https://www.terraform.io/downloads.html) installed on your machine.

2. **Authenticate to Terraform Cloud**:
   You need to authenticate Terraform CLI with your **Terraform Cloud API Token** to allow the CLI to interact with Terraform Cloud:

   ```bash
   terraform login
   ```

   This will open a browser and prompt you to authenticate with Terraform Cloud.

3. **Update Backend Configuration**: 
   If you're working locally, make sure your backend configuration is included in the Terraform files. Add the following to your `main.tf` or `backend.tf` to point to the correct **Terraform Cloud** organization and workspace:

   ```hcl
   terraform {
     backend "remote" {
       organization = "<YOUR_ORGANIZATION>"

       workspaces {
         name = "<YOUR_WORKSPACE>"
       }
     }
   }
   ```

   This ensures that your state will be stored remotely in **Terraform Cloud**.

#### Running Terraform Commands Locally

Once the backend is configured and you've authenticated the CLI, you can run the following commands:

1. **Initialize the Terraform Working Directory**:

   ```bash
   terraform init
   ```

   This command initializes your Terraform working directory and configures it to use Terraform Cloud as the backend.

2. **Plan the Terraform Changes**:

   ```bash
   terraform plan
   ```

   This will generate an execution plan, showing what changes Terraform will make based on your configuration.

3. **Apply the Terraform Changes**:

   ```bash
   terraform apply
   ```

   This command will apply the changes locally, but the state will still be managed remotely in Terraform Cloud.

By following these steps, you can test and apply your changes locally while ensuring the state is securely stored and managed by Terraform Cloud.

### Conclusion

With this setup, Terraform can manage the infrastructure, and any necessary output values are stored securely in GitHub Secrets for later use. Be sure to keep your secrets secure and only use them in the intended workflows.
