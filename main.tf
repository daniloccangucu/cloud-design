# Define the AWS provider and region
provider "aws" {
  region = "eu-north-1"  # Set the AWS region to Northern Europe
}

# Create a Virtual Private Cloud (VPC)
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"  # The IP range for the VPC, allows 65,536 addresses
}

# Create 2 public subnets within the VPC
resource "aws_subnet" "public_az1" {
  vpc_id                  = aws_vpc.main.id  # Associate the subnet with the VPC created above
  cidr_block              = "10.0.3.0/24"  # The IP range for the subnet, allows 256 addresses
  map_public_ip_on_launch = true
  availability_zone       = "eu-north-1a"
}

resource "aws_subnet" "public_az2" {
  vpc_id                  = aws_vpc.main.id  # Associate the subnet with the VPC created above
  cidr_block              = "10.0.4.0/24"  # The IP range for the subnet, allows 256 addresses
  map_public_ip_on_launch = true
  availability_zone       = "eu-north-1b"
}

# Create an Internet Gateway to allow internet access to the VPC
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id  # Attach the Internet Gateway to the VPC
}

# Create a Route Table for the public subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id  # Associate the Route Table with the VPC

  route {
    cidr_block = "0.0.0.0/0"  # Route all traffic (0.0.0.0/0) to the Internet Gateway
    gateway_id = aws_internet_gateway.main.id  # Specify the Internet Gateway
  }
}

# Associate the public subnets with the Route Table
resource "aws_route_table_association" "public_az1" {
  subnet_id      = aws_subnet.public_az1.id   # Specify the public subnet
  route_table_id = aws_route_table.public.id  # Associate with the public Route Table
}

resource "aws_route_table_association" "public_az2" {
  subnet_id      = aws_subnet.public_az2.id  # Specify the public subnet
  route_table_id = aws_route_table.public.id  # Associate with the public Route Table
}

# Security group for Network Load Balancer
resource "aws_security_group" "inventory_nlb_sg" {
  vpc_id = aws_vpc.main.id

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

# Create ECS Cluster for Inventory Services
resource "aws_ecs_cluster" "inventory-cluster" {
  name = "inventory-cluster"
}

# Security group for ECS Service
resource "aws_security_group" "inventory_database" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 5432             # Allow incoming traffic on port 5432 (PostgreSQL)
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from any IP address
  }

  egress {
    from_port   = 0              # Allow all outbound traffic
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Network Load Balancer
resource "aws_lb" "inventory_nlb" {
  name               = "inventory-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.public_az1.id, aws_subnet.public_az2.id]
}

# Create Target Group
resource "aws_lb_target_group" "inventory_tg" {
  name       = "inventory-tg"
  port       = 5432
  protocol   = "TCP"
  vpc_id     = aws_vpc.main.id
  target_type = "ip"
}

# Create Listener
resource "aws_lb_listener" "tcp" {
  load_balancer_arn = aws_lb.inventory_nlb.arn
  port              = "5432"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.inventory_tg.arn
  }
}

# Create ECS Task Definition
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

# Create ECS Service
resource "aws_ecs_service" "inventory_database" {
  name            = "inventory-database-service"
  cluster         = aws_ecs_cluster.inventory-cluster.id
  task_definition = aws_ecs_task_definition.inventory_database.arn
  desired_count   = 1

  launch_type = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets         = [aws_subnet.public_az1.id, aws_subnet.public_az2.id]
    security_groups = [aws_security_group.inventory_database.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.inventory_tg.arn
    container_name   = "inventory-database"
    container_port   = 5432
  }
}
