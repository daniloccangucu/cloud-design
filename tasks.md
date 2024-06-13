### cloud-design Task List

### Day 1: Project Setup
- [x] Select AWS as the cloud provider and document reasons for the choice.
- [x] Set up AWS account, IAM users, roles, and billing alerts.
- [x] Install and configure Terraform with AWS CLI.
- [x] **Documentation**: Document the setup process, reasons for AWS selection, and initial configuration.

### Day 2-5: Initial Infrastructure Design
- [x] Design basic infrastructure (VPC, subnets, route tables).
- [x] Create initial Terraform configuration files for VPC setup.

- **Inventory-database**
  - [x] Updated Dockerfile.
  - [x] Built and tested Docker image locally.
  - [x] Deployed in ECS (cluster, task, deployment).
  - [x] Logs in CloudWatch
  - [ ] Data Encryption

- **Inventory-app**
  - [x] Deploy in ECS (cluster, task, deployment).
  - [x] Logs in CloudWatch

- **Billing-database**
  - [x] Update Dockerfile.
  - [x] Deploy in ECS (cluster, task, deployment).
  - [x] Logs in CloudWatch
  - [ ] Data Encryption

- **Billing-app**
  - [x] Update Dockerfile.
  - [x] Deploy in ECS (cluster, task, deployment).
  - [x] Logs in CloudWatch

- **RabbitMQ**
  - [x] Update Dockerfile.
  - [x] Deploy in ECS (cluster, task, deployment).
  - [x] Logs in CloudWatch

- **API-gateway**
  - [x] Update Dockerfile.
  - [x] Deploy in ECS (cluster, task, deployment).
  - [x] Logs in CloudWatch

### Day 6: Load Balancing and Service Communication
- Set up AWS Elastic Load Balancer (ELB) for the ECS services.
  - [x] Network Load Balancer for inventory services.
  - [x] Network Load Balancer for billing services.
  - [x] Network Load Balancer for api-gateway.

- [x] Ensure secure communication between services.
- [x] **Documentation**: Document load balancing setup and security configurations.

### Day 7: Security Enhancements
- [ ] Implement AWS Certificate Manager (ACM) for HTTPS.
- [ ] Secure API endpoints with Amazon API Gateway.
- [ ] Set up AWS Inspector for regular vulnerability scanning.
- [ ] Implement data encryption in databases.
- [ ] **Documentation**: Record security configurations, setup processes, and testing results. Create security architecture diagrams.

### Day 8: Monitoring and Logging
- [x] Set up CloudWatch for monitoring metrics and alarms.
- [ ] Enable CloudTrail and configure S3 for log storage.
- [ ] Ensure alerts and notifications via SNS.
- [ ] **Documentation**: Record monitoring setup, logging mechanisms, and alert configurations.

### Day 10: Documentation Focus
- [ ] AUDIT: "Does the README.md file contain all the necessary information about the solution (prerequisites, setup, configuration, usage, ...)?"