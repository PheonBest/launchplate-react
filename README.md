# Launchplate React

A React application deployed to AWS using Terraform with multiple environment support.

- **Frontend**: React **static** **SPA** hosted on S3 and distributed via CloudFront
- **DNS**: Managed by either **CloudFlare** or **Route53** (environment-dependent)
- **Optional Features**: S3 buckets encryption (disabled by default), WAF protection (disabled by default)
- **SSL Certificates**: AWS ACM with DNS validation
- **Redirect from root to www**: Enabled by default when using Cloudflare, based on Page Rules. This feature isn't supported when using Route53.

```
├── .github/
│   ├── actions/          # Custom GitHub Actions
│   └── workflows/        # GitHub Actions workflows
├── terraform/
│   ├── live              # Workspace-CLI environments
│   ├── modules/          # Reusable Terraform modules
│   └── bootstrap/        # Bootstrap shared TF state
└── web/                      # React application source code
```

Make a table with three rows (production, staging, development) with two columns (root url redirected to www, www url)

| Environment | Root URL (redirected to www) | WWW URL |
|-------------|---------------------------|---------|
| Production  | [launchplate-react.gloweet.com](https://launchplate-react.gloweet.com)                       | [www.launchplate-react.gloweet.com](https://www.launchplate-react.gloweet.com) |
| Staging     | [stg-launchplate-react.gloweet.com](https://stg-launchplate-react.gloweet.com)                       | [www.stg-launchplate-react.gloweet.com](https://www.stg-launchplate-react.gloweet.com) |
| Development | [dev-launchplate-react.gloweet.com](https://dev-launchplate-react.gloweet.com)                       | [www.dev-launchplate-react.gloweet.com](https://www.dev-launchplate-react.gloweet.com) |

## Documentation
- [Infrastructure and CI/CD pipeline setup](/terraform/README.md)
- [Use pre-commit](/docs/pre-commit.md)

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
cd terraform/live
# Initialize Terraform
terraform init

# Initialize Workspaces
terraform workspace new dev
terraform workspace new stg
terraform workspace new prod
terraform workspace list

terraform workspace select dev

# Plan changes
terraform plan

# Apply changes
terraform apply
```

### Pushing website to S3

To push the build website to S3, run the following command:

```bash
aws s3 sync ../../web/dist s3://dev-launchplate-react-primary
```

### Deployment Process

- Push to main or release/\* branch to auto-deploy to 'qa' environment
- Deploy manually to any environment using workflow_dispatch in GitHub Actions
