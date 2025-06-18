# Launchplate React

A React application deployed to AWS using Terraform with multiple environment support.

## Project Structure

```
├── .github/
│   ├── actions/          # Custom GitHub Actions
│   └── workflows/        # GitHub Actions workflows
├── terraform/
│   ├── live              # Workspace-CLI single entry for multiple environments
│   ├── modules/          # Reusable Terraform modules
│   └── bootstrap/        # Bootstrap shared TF state
└── web/                  # React application source code
```

## Development Setup

1. **Prerequisites**

   - Node.js 20+
   - pnpm 10+
   - AWS CLI configured
   - Terraform CLI 1.12+

2. **Install dependencies**

   ```bash
   pnpm install
   ```

3. **Run locally**

   ```bash
   pnpm dev
   ```

4. **Run tests**

   ```bash
   pnpm test
   ```

5. **Build for specific environment**
   ```bash
   pnpm build:qa      # Build for QA
   pnpm build:staging # Build for Staging
   pnpm build:production  # Build for Production
   ```

## Infrastructure Management

### Working with Terraform Workspaces

This project uses Terraform Workspaces to manage multiple environments (qa, staging, production).

```bash
# Initialize Terraform
terraform init

# Select workspace
terraform workspace select qa     # or staging, production

# Plan changes
terraform plan

# Apply changes
terraform apply
```

### Deployment Process

- Push to main or release/\* branch to auto-deploy to 'qa' environment
- Use workflow_dispatch in GitHub Actions to select environment

## Architecture

- **Frontend**: React application hosted on S3 and distributed via CloudFront
- **DNS**: Managed by either CloudFlare or Route53 (environment-dependent)
- **SSL Certificates**: AWS ACM with DNS validation
