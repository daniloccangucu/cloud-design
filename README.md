## cloud-design

### Selection of AWS as the Cloud Provider
I chose AWS for its comprehensive services, global presence, and robust security features. AWS offers essential tools for building a scalable and secure infrastructure, ensures high availability with its global network, and provides strong security and compliance measures.

### Project Setup

- **Set up AWS account, IAM users, roles, and billing alerts**:
  - Created an AWS account.
  - Set up an IAM user (`cd-admin`) with necessary permissions.
  - Enabled billing alerts and created a CloudWatch alarm for cost monitoring.

- **Install and configure Terraform with AWS CLI**:
  - Installed AWS CLI and configured it with access keys and default settings.
  - Installed Terraform and initialized it in the project directory.
  - Created a basic `main.tf` configuration file specifying the AWS provider and region.
  - Added `.terraform/`, `terraform.tfstate`, `terraform.tfstate.backup`, and `.terraform.lock.hcl` to `.gitignore`.

### Terraform Basic Configuration
```hcl
provider "aws" {
  region = "eu-north-1"
}
```