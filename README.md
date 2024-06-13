## cloud-design

### Selection of AWS as the Cloud Provider
AWS was chosen for its comprehensive services, global presence, and robust security features. It offers essential tools for building a scalable and secure infrastructure, ensures high availability with its global network, and provides strong security and compliance measures.

### Project Setup
- **Install and configure Terraform with AWS CLI**:
  - Installed AWS CLI and configured it with access keys and default settings.
  - Installed Terraform and initialized it in the project directory.
  - Created a basic `main.tf` configuration file specifying the AWS provider and region.
  - Added `.terraform/`, `terraform.tfstate`, `terraform.tfstate.backup`, and `.terraform.lock.hcl` to `.gitignore`.

### Initial Infrastructure Design
- **Basic infrastructure (VPC, subnets, route tables)**:
  - Designed three VPCs for Inventory, Billing, and API Gateway services with CIDR blocks `10.0.0.0/16`, `10.1.0.0/16`, and `10.2.0.0/16`.
  - Created public subnets within each VPC.
  - Configured Internet Gateways and Route Tables for each public subnet.
  - Enabled billing alerts and created a CloudWatch alarm for cost monitoring.

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

## Architecture Design

### Scalability
The architecture leverages key AWS services to handle varying workloads:

- **Network Load Balancers (NLBs)**: Distribute traffic efficiently across instances.
- **ECS Clusters**: Manage and scale containerized applications dynamically.
- **Auto Scaling**: Adjusts ECS tasks based on demand.
- **CloudWatch Monitoring**: Enables real-time performance monitoring and automatic responses.

#### Load Balancing Setup
- **Network Load Balancers (NLBs)**: Configured to handle traffic for Inventory, Billing, and API Gateway services. Each NLB is associated with target groups that direct traffic to the appropriate ECS tasks.
  - **Inventory NLB**: Handles traffic for the inventory service.
  - **Billing NLB**: Manages requests for the billing service.
  - **API Gateway NLB**: Routes traffic to the API gateway service.
- **Listeners and Target Groups**: Each NLB has listeners on specific ports that forward requests to target groups, ensuring traffic is distributed evenly across ECS tasks.

### Terraform Configuration for Scalability

- **NLBs**: Configured with listeners and target groups.
- **ECS Services**: Defined with appropriate counts, subnets, and security groups.
- **CloudWatch Logs**: Set up for monitoring and diagnostics.

### High Availability and Fault Tolerance
To ensure high availability and fault tolerance, the architecture incorporates:

1. **ECS Services with Desired Count**: Ensures tasks are automatically restarted if they fail.
2. **Multiple Availability Zones**: Subnets are created in multiple availability zones to prevent single points of failure.
3. **Load Balancers**: Distribute traffic across multiple instances of the ECS tasks.
4. **Auto Scaling**: Adjusts the number of ECS tasks based on CPU utilization.
5. **CloudWatch Alarms**: Monitor CPU utilization and trigger scaling actions to maintain performance.

### Cost-effectiveness
The architecture is designed to be cost-effective:

1. **Auto Scaling**: Scales resources up and down based on demand, ensuring efficient use of resources.
2. **Right-Sizing**: Task definitions specify appropriate CPU and memory limits to avoid over-provisioning.
3. **Load Balancers**: Efficiently distribute traffic to optimize resource usage.
4. **Resource Grouping**: Segregates services into different VPCs to manage costs effectively.

### Simplicity
The architecture is straightforward and free of unnecessary complexity while still fulfilling project requirements:

1. **Modular Design**: Uses separate VPCs for Inventory, Billing, and API Gateway services.
2. **Infrastructure as Code**: Terraform ensures a clear, consistent, and reproducible infrastructure.
3. **ECS and Fargate**: Abstracts away the need to manage underlying EC2 instances.
4. **Security Groups**: Clearly defined for each service, ensuring only necessary ports are open.

#### Security Configurations
- **Security Groups**: Implemented for each service to control inbound and outbound traffic. Each security group specifies rules to allow only necessary traffic:
  - **Inventory Service**: Security groups allow traffic on ports 5432 (database) and 8080 (app).
  - **Billing Service**: Security groups allow traffic on ports 5432 (database), 8080 (app), and 5672 (RabbitMQ).
  - **API Gateway**: Security groups allow traffic on port 3000.
- **IAM Roles and Policies**: Defined IAM roles with appropriate permissions for ECS task execution, ensuring secure access to required AWS services.
- **Data Encryption**: Implement encryption for sensitive data both in transit and at rest using AWS services like AWS KMS for managing encryption keys.