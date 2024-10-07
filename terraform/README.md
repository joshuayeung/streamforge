## Terraform Cloud Backend Setup

This project uses **Terraform Cloud** as the backend to manage the Terraform state remotely. To avoid exposing sensitive information such as the organization name and workspace name, these values are passed securely using GitHub Secrets and environment variables.

### Steps to Set Up Terraform Cloud Backend

1. **Modify `backend.tf` to Use Environment Variables**

   In the `backend.tf` file, the organization name and workspace name are referenced using variables instead of being hardcoded. This ensures that these values can be injected securely at runtime.

2. **Define the Variables in `variables.tf`**

   The variables for the organization and workspace names are defined in the `variables.tf` file:

3. **Configure GitHub Action to Inject Secrets**

   In the GitHub Actions workflow (e.g., `deploy-infra-change.yml`), the secrets are injected as environment variables using the `TF_VAR` prefix. This enables Terraform to automatically use the injected variables during deployment.

4. **Add Secrets to GitHub**

   To securely store and pass the organization and workspace names, set them up as GitHub Secrets:

   - Go to your GitHub repository.
   - Navigate to **Settings** → **Secrets and variables** → **Actions**.
   - Add the following secrets:
     - `TERRAFORM_ORG`: Your Terraform Cloud organization name.
     - `TERRAFORM_WORKSPACE`: Your Terraform Cloud workspace name.
     - `TERRAFORM_CLOUD_API_TOKEN`: Your Terraform Cloud API token.

5. **Run GitHub Action**

   When the GitHub Action is triggered, it will automatically fetch the secrets and inject them into the environment as Terraform variables. Terraform will then use these values to initialize the backend and manage the infrastructure.

---

### Benefits of This Setup

- **Security:** Sensitive information such as the Terraform organization and workspace names are not hardcoded in the repository but stored securely in GitHub Secrets.
- **Automation:** The process of passing these values to Terraform is fully automated through GitHub Actions, making the workflow seamless.
- **Remote State Management:** Using Terraform Cloud as the backend ensures that the state is managed remotely and securely, allowing collaboration and preventing state conflicts.
