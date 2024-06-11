# Define the AWS provider and region
provider "aws" {
  region = "eu-north-1"  # Set the AWS region to Northern Europe
}

# Create a Virtual Private Cloud (VPC) for Inventory Services
resource "aws_vpc" "inventory_vpc" {
  cidr_block = "10.0.0.0/16"  # The IP range for the VPC, allows 65,536 addresses
}

# Create a Virtual Private Cloud (VPC) for Billing Services
resource "aws_vpc" "billing_vpc" {
  cidr_block = "10.1.0.0/16"  # The IP range for the VPC, allows 65,536 addresses
}

# Create 2 public subnets within the Inventory VPC
resource "aws_subnet" "inventory_public_az1" {
  vpc_id                  = aws_vpc.inventory_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-north-1a"
}

resource "aws_subnet" "inventory_public_az2" {
  vpc_id                  = aws_vpc.inventory_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-north-1b"
}

# Create 2 public subnets within the Billing VPC
resource "aws_subnet" "billing_public_az1" {
  vpc_id                  = aws_vpc.billing_vpc.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-north-1a"
}

resource "aws_subnet" "billing_public_az2" {
  vpc_id                  = aws_vpc.billing_vpc.id
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-north-1b"
}

# Create Internet Gateways for both VPCs
resource "aws_internet_gateway" "inventory_igw" {
  vpc_id = aws_vpc.inventory_vpc.id
}

resource "aws_internet_gateway" "billing_igw" {
  vpc_id = aws_vpc.billing_vpc.id
}

# Create Route Tables for the public subnets in both VPCs
resource "aws_route_table" "inventory_public_rt" {
  vpc_id = aws_vpc.inventory_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.inventory_igw.id
  }
}

resource "aws_route_table" "billing_public_rt" {
  vpc_id = aws_vpc.billing_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.billing_igw.id
  }
}

# Associate the public subnets with their Route Tables
resource "aws_route_table_association" "inventory_public_az1" {
  subnet_id      = aws_subnet.inventory_public_az1.id
  route_table_id = aws_route_table.inventory_public_rt.id
}

resource "aws_route_table_association" "inventory_public_az2" {
  subnet_id      = aws_subnet.inventory_public_az2.id
  route_table_id = aws_route_table.inventory_public_rt.id
}

resource "aws_route_table_association" "billing_public_az1" {
  subnet_id      = aws_subnet.billing_public_az1.id
  route_table_id = aws_route_table.billing_public_rt.id
}

resource "aws_route_table_association" "billing_public_az2" {
  subnet_id      = aws_subnet.billing_public_az2.id
  route_table_id = aws_route_table.billing_public_rt.id
}

# Security Groups for Inventory Services
resource "aws_security_group" "inventory_nlb_sg" {
  vpc_id = aws_vpc.inventory_vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "inventory_database" {
  vpc_id = aws_vpc.inventory_vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "inventory_app" {
  vpc_id = aws_vpc.inventory_vpc.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Groups for Billing Services
resource "aws_security_group" "billing_nlb_sg" {
  vpc_id = aws_vpc.billing_vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "billing_database" {
  vpc_id = aws_vpc.billing_vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group for RabbitMQ
resource "aws_security_group" "rabbitmq" {
  vpc_id = aws_vpc.billing_vpc.id

  ingress {
    from_port   = 5672
    to_port     = 5672
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 15672
    to_port     = 15672
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Network Load Balancers for both VPCs
resource "aws_lb" "inventory_nlb" {
  name               = "inventory-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.inventory_public_az1.id, aws_subnet.inventory_public_az2.id]
}

resource "aws_lb" "billing_nlb" {
  name               = "billing-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.billing_public_az1.id, aws_subnet.billing_public_az2.id]
}

# Create Target Groups
resource "aws_lb_target_group" "inventory_tg" {
  name       = "inventory-tg"
  port       = 5432
  protocol   = "TCP"
  vpc_id     = aws_vpc.inventory_vpc.id
  target_type = "ip"
}

resource "aws_lb_target_group" "inventory_app_tg" {
  name       = "inventory-app-tg"
  port       = 8080
  protocol   = "TCP"
  vpc_id     = aws_vpc.inventory_vpc.id
  target_type = "ip"
}

resource "aws_lb_target_group" "billing_tg" {
  name       = "billing-tg"
  port       = 5432
  protocol   = "TCP"
  vpc_id     = aws_vpc.billing_vpc.id
  target_type = "ip"
}

resource "aws_lb_target_group" "rabbitmq_tg" {
  name       = "rabbitmq-tg"
  port       = 5672
  protocol   = "TCP"
  vpc_id     = aws_vpc.billing_vpc.id
  target_type = "ip"
}

# Create Listeners
resource "aws_lb_listener" "inventory_db_listener" {
  load_balancer_arn = aws_lb.inventory_nlb.arn
  port              = "5432"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.inventory_tg.arn
  }
}

resource "aws_lb_listener" "inventory_app_listener" {
  load_balancer_arn = aws_lb.inventory_nlb.arn
  port              = "8080"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.inventory_app_tg.arn
  }
}

resource "aws_lb_listener" "billing_db_listener" {
  load_balancer_arn = aws_lb.billing_nlb.arn
  port              = "5432"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.billing_tg.arn
  }
}

resource "aws_lb_listener" "rabbitmq_listener" {
  load_balancer_arn = aws_lb.billing_nlb.arn
  port              = "5672"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rabbitmq_tg.arn
  }
}

# Create ECS Clusters
resource "aws_ecs_cluster" "inventory_cluster" {
  name = "inventory-cluster"
}

resource "aws_ecs_cluster" "billing_cluster" {
  name = "billing-cluster"
}

# Create ECS Task Definitions
resource "aws_ecs_task_definition" "inventory_database" {
  family                   = "inventory_database"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name  = "inventory-database"
    image = "danilocangucu/inventory-database:latest"
    essential = true
    portMappings = [{
      containerPort = 5432
      hostPort      = 5432
    }]
    environment = [
      {
        name  = "POSTGRES_USER"
        value = "postgres"
      },
      {
        name  = "POSTGRES_PASSWORD"
        value = "t3st"
      }
    ]
  }])
}

resource "aws_ecs_task_definition" "inventory_app" {
  family                   = "inventory_app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name  = "inventory-app"
    image = "danilocangucu/inventory-app:latest"
    essential = true
    portMappings = [{
      containerPort = 8080
      hostPort      = 8080
    }]
    environment = [
      {
        name  = "PGUSER"
        value = "postgres"
      },
      {
        name  = "PGPASSWORD"
        value = "t3st"
      },
      {
        name  = "PGDATABASE"
        value = "movies"
      },
      {
        name  = "PGHOST"
        value = aws_lb.inventory_nlb.dns_name  # Value from LB dynamically
      },
      {
        name  = "PGPORT"
        value = "5432"
      },
      {
        name  = "INVENTORY_PORT"
        value = "8080"
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/inventory-app"
        awslogs-region        = "eu-north-1"
        awslogs-stream-prefix = "ecs"
      }
    }
  }])

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_ecs_task_definition" "billing_database" {
  family                   = "billing_database"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name  = "billing-database"
    image = "danilocangucu/billing-database:latest"
    essential = true
    portMappings = [{
      containerPort = 5432
      hostPort      = 5432
    }]
    environment = [
      {
        name  = "POSTGRES_USER"
        value = "postgres"
      },
      {
        name  = "POSTGRES_PASSWORD"
        value = "t3st"
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/billing-database"
        awslogs-region        = "eu-north-1"
        awslogs-stream-prefix = "ecs"
      }
    }
  }])

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_ecs_task_definition" "rabbitmq" {
  family                   = "rabbitmq"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name  = "rabbitmq"
    image = "danilocangucu/rabbit-cloud_design:latest"
    essential = true
    portMappings = [
      {
        containerPort = 5672
        hostPort      = 5672
      },
      {
        containerPort = 15672
        hostPort      = 15672
      }
    ]
    environment = [
      {
        name  = "RABBITMQ_DEFAULT_USER"
        value = "danilo"
      },
      {
        name  = "RABBITMQ_DEFAULT_PASS"
        value = "dan1234"
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/rabbitmq"
        awslogs-region        = "eu-north-1"
        awslogs-stream-prefix = "ecs"
      }
    }
  }])

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
}

# IAM role for ECS tasks executions
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# CloudWatch log groups
resource "aws_cloudwatch_log_group" "inventory_app" {
  name              = "/ecs/inventory-app"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "billing_database" {
  name              = "/ecs/billing-database"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "rabbitmq" {
  name              = "/ecs/rabbitmq"
  retention_in_days = 7
}

# Create ECS Services
resource "aws_ecs_service" "inventory_database" {
  name            = "inventory-database-service"
  cluster         = aws_ecs_cluster.inventory_cluster.id
  task_definition = aws_ecs_task_definition.inventory_database.arn
  desired_count   = 1

  launch_type = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets         = [aws_subnet.inventory_public_az1.id, aws_subnet.inventory_public_az2.id]
    security_groups = [aws_security_group.inventory_database.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.inventory_tg.arn
    container_name   = "inventory-database"
    container_port   = 5432
  }
}

resource "aws_ecs_service" "inventory_app" {
  name            = "inventory-app-service"
  cluster         = aws_ecs_cluster.inventory_cluster.id
  task_definition = aws_ecs_task_definition.inventory_app.arn
  desired_count   = 1

  launch_type = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets         = [aws_subnet.inventory_public_az1.id, aws_subnet.inventory_public_az2.id]
    security_groups = [aws_security_group.inventory_app.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.inventory_app_tg.arn
    container_name   = "inventory-app"
    container_port   = 8080
  }
}

resource "aws_ecs_service" "billing_database" {
  name            = "billing-database-service"
  cluster         = aws_ecs_cluster.billing_cluster.id
  task_definition = aws_ecs_task_definition.billing_database.arn
  desired_count   = 1

  launch_type = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets         = [aws_subnet.billing_public_az1.id, aws_subnet.billing_public_az2.id]
    security_groups = [aws_security_group.billing_database.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.billing_tg.arn
    container_name   = "billing-database"
    container_port   = 5432
  }
}

resource "aws_ecs_service" "rabbitmq" {
  name            = "rabbitmq-service"
  cluster         = aws_ecs_cluster.billing_cluster.id
  task_definition = aws_ecs_task_definition.rabbitmq.arn
  desired_count   = 1

  launch_type = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets         = [aws_subnet.billing_public_az1.id, aws_subnet.billing_public_az2.id]
    security_groups = [aws_security_group.rabbitmq.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.rabbitmq_tg.arn
    container_name   = "rabbitmq"
    container_port   = 5672
  }
}

# Output Load Balancer DNS Names
output "inventory_database_lb_dns" {
  value = aws_lb.inventory_nlb.dns_name
}

output "billing_database_lb_dns" {
  value = aws_lb.billing_nlb.dns_name
}
