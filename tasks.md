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
  - [ ] Logs in CloudWatch

- **Inventory-app**
  - [x] Deploy in ECS (cluster, task, deployment).
  - [x] Logs in CloudWatch

- **Billing-database**
  - [x] Update Dockerfile.
  - [x] Deploy in ECS (cluster, task, deployment).
  - [x] Logs in CloudWatch

- **Billing-app**
  - [x] Update Dockerfile.
  - [x] Deploy in ECS (cluster, task, deployment).

- **RabbitMQ**
  - [x] Update Dockerfile.
  - [x] Deploy in ECS (cluster, task, deployment).

- **API-gateway**
  - [x] Update Dockerfile.
  - [x] Deploy in ECS (cluster, task, deployment).

### Day 6: Load Balancing and Service Communication
- Set up AWS Elastic Load Balancer (ELB) for the ECS services.
  - [x] Network Load Balancer for inventory services.
  - [x] Network Load Balancer for billing services.
  - [x] Network Load Balancer for api-gateway.

- [x] Ensure secure communication between services.
- [ ] Test the load balancing and inter-service communication.
- [ ] **Documentation**: Document load balancing setup, security configurations, and test results.

### Day 7: Security Enhancements
- [ ] Implement AWS Certificate Manager (ACM) for HTTPS.
- [ ] Secure API endpoints with Amazon API Gateway.
- [ ] Ensure databases and private resources are secure within the VPC.
- [ ] Set up AWS Inspector for regular vulnerability scanning.
- [ ] Implement data encryption for S3 buckets and RDS databases.
- [ ] **Documentation**: Record security configurations, setup processes, and testing results. Create security architecture diagrams.

### Day 8: Monitoring and Logging
- [x] Set up CloudWatch for monitoring metrics and alarms.
- [ ] Enable CloudTrail and configure S3 for log storage.
- [ ] Ensure alerts and notifications via SNS.
- [ ] **Documentation**: Record monitoring setup, logging mechanisms, and alert configurations.

### Day 9: Cost Management
- [ ] Explore AWS Cost Explorer and Budgets for cost management.
- [ ] Implement cost-saving measures (reserved/spot instances, S3 lifecycle policies).
- [ ] Update Terraform files with cost management configurations.
- [ ] **Documentation**: Document cost management strategies, Terraform updates, and validate cost-saving measures.

### Day 10: Documentation Focus
- [ ] Compile and finalize all previous documentation.
- [ ] Ensure comprehensive and clear documentation with diagrams created on previous days.
- [ ] **Documentation**: Finalize and organize all documentation into a cohesive format.

### Day 11: Testing and Validation
- [ ] Perform end-to-end testing of the infrastructure.
- [ ] Validate scalability, security, and cost-efficiency.
- [ ] Fix any identified issues.
- [ ] **Documentation**: Record testing procedures, results, and any fixes applied. Update diagrams if necessary.

### Day 12: Final Review and Audit Preparation
- [ ] Review all configurations, Terraform files, and documentation.
- [ ] Prepare detailed answers for audit questions.
- [ ] Ensure everything meets project requirements.
- [ ] **Documentation**: Update and finalize documentation based on the review.

### Day 13: Buffer Day
- [ ] Address any remaining tasks or issues.
- [ ] Conduct final testing and validation.
- [ ] **Documentation**: Make any final updates to documentation based on last-minute changes.

### Day 14: Submission
- [ ] Compile all documentation and configurations.
- [ ] Submit the project for review.
- [ ] Confirm submission was successful.
- [ ] **Documentation**: Ensure the submission process is well-documented for future reference.