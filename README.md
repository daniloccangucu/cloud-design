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

### Initial Infrastructure Design
- **Design basic infrastructure (VPC, subnets, route tables)**:
  - Designed a VPC with CIDR block `10.0.0.0/16`.
  - Created public (`10.0.1.0/24`) and private (`10.0.2.0/24`) subnets.
  - Configured an Internet Gateway and a Route Table for the public subnet.

- **Create initial Terraform configuration files for VPC setup**:
  - Defined resources in `main.tf` for VPC, subnets, Internet Gateway, and Route Table.

### Network Architecture Diagram
![Network Architecture Diagram](https://i.postimg.cc/vZCpBwm8/diagram-export-07-06-2024-18-57-55.png)
