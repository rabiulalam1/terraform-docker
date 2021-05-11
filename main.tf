terraform {
  backend "s3" {
    bucket         = "rabiul-test-tfstate"
    key            = "test-app.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "rabiul-tfstate-lock"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.39.0"
    }
  }

  required_version = "~> 0.15"
}

provider "aws" {
  region = "us-east-1"
}

data "aws_region" "current" {}

module "bastion-server" {
  source = "./modules/bastion"
  env_prefix = {
    Project  = var.project
    Snapshot = var.snapshot
  }
}

module "network" {
  source                      = "./modules/network"
  region                      = data.aws_region.current.name
  vpc_cidr_block              = var.vpc_cidr_block
  subnet_cidr_block_public_a  = var.subnet_cidr_block_public_a
  subnet_cidr_block_public_b  = var.subnet_cidr_block_public_b
  subnet_cidr_block_private_a = var.subnet_cidr_block_private_a
  subnet_cidr_block_private_b = var.subnet_cidr_block_private_b
}

module "database" {
  source = "./modules/database"
  db_username = var.db_username
  db_password = var.db_password
  subnet_private_a = module.network.subnet_private_a
  subnet_private_b = module.network.subnet_private_b
}

# module "test-subnet" {
#   source            = "./modules/subnet"
#   subnet_cidr_block = var.subnet_cidr_block
#   env_prefix        = var.env_prefix
#   vpc_id            = aws_vpc.test-vpc.id
# }

# module "test-server" {
#   source              = "./modules/webserver"
#   image_name          = var.image_name
#   vpc_id              = aws_vpc.test-vpc.id
#   my_ip               = var.my_ip
#   env_prefix          = var.env_prefix
#   instance_type       = var.instance_type
#   subnet_id           = module.test-subnet.subnet.id
#   public_key_location = var.public_key_location
#   availability_zone   = var.availability_zone
# }

# resource "aws_cloudwatch_dashboard" "main" {
#   dashboard_name = "test-dashboard"

#   dashboard_body = <<EOF
# {
#     "widgets": [
#         {
#             "type": "explorer",
#             "width": 24,
#             "height": 15,
#             "x": 0,
#             "y": 0,
#             "properties": {
#                 "metrics": [
#                     {
#                         "metricName": "CPUUtilization",
#                         "resourceType": "AWS::EC2::Instance",
#                         "stat": "Average"
#                     },
#                     {
#                         "metricName": "NetworkIn",
#                         "resourceType": "AWS::EC2::Instance",
#                         "stat": "Average"
#                     },
#                     {
#                         "metricName": "NetworkOut",
#                         "resourceType": "AWS::EC2::Instance",
#                         "stat": "Average"
#                     }
#                 ],
#                 "aggregateBy": {
#                     "key": "InstanceType",
#                     "func": "MAX"
#                 },
#                 "labels": [
#                     {
#                         "key": "State",
#                         "value": "running"
#                     }
#                 ],
#                 "widgetOptions": {
#                     "legend": {
#                         "position": "bottom"
#                     },
#                     "view": "timeSeries",
#                     "rowsPerPage": 8,
#                     "widgetsPerRow": 2
#                 },
#                 "period": 300,
#                 "splitBy": "AvailabilityZone",
#                 "title": "Running EC2 Instances by AZ"
#             }
#         }
#     ]
# }
# EOF
# }