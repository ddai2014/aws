data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name = "name"
    values = [var.ami_filter.name]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = [var.ami_filter.owner]
}

# VPC Module
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "${var.environment.network_prefix}.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["${var.environment.network_prefix}.1.0/24", "${var.environment.network_prefix}.2.0/24"]
  public_subnets  = ["${var.environment.network_prefix}.101.0/24", "${var.environment.network_prefix}.102.0/24"]

  tags = {    
    environment = var.environment.name
  }
}

# Autoscaling Group Module
module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name                = "${var.environment.name}-asg"
  min_size            = var.asg_min
  max_size            = var.asg_max
  vpc_zone_identifier = module.vpc.public_subnets
  image_id            = data.aws_ami.app_ami.id
  instance_type       = var.instance_type
  target_group_arns   = module.alb.target_group_arns
  security_groups     = [module.sg.security_group_id]
  
  tags = {    
    environment = var.environment.name
  }
}

# Application Load Balance Module
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "${var.environment.name}-alb"

  load_balancer_type = "application"

  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [module.sg.security_group_id]

  target_groups = [
    {
      name_prefix      = "${var.environment.name}-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"      
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    environment = var.environment.name
  }
}

# Security Group Module
module "sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "${var.environment.name}-web-server"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id
  ingress_rules = ["https-443-tcp","http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}

