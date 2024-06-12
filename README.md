Sure, here's an updated README that reflects your progress and setup:

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
  - Designed three VPCs for Inventory, Billing, and API Gateway services with CIDR blocks `10.0.0.0/16`, `10.1.0.0/16`, and `10.2.0.0/16` respectively.
  - Created public subnets within each VPC.
  - Configured Internet Gateways and Route Tables for each public subnet.

### Network Architecture Diagram
![Network Architecture Diagram](https://i.postimg.cc/vZCpBwm8/diagram-export-07-06-2024-18-57-55.png)

### Terraform Configuration

The Terraform configuration includes the setup of VPCs, subnets, internet gateways, route tables, security groups, load balancers, target groups, ECS clusters, task definitions, services, and CloudWatch log groups.

### Summary of Terraform Configuration:
- Defined the AWS provider and region.
- Created three VPCs for Inventory, Billing, and API Gateway services.
- Set up public subnets, internet gateways, and route tables.
- Configured security groups for each service.
- Set up Network Load Balancers and Target Groups.
- Created ECS clusters, task definitions, and services for each component.
- Configured CloudWatch log groups for monitoring.
