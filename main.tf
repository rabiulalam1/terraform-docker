provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
  token      = var.token
}

resource "aws_vpc" "test-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name : "${var.env_prefix}-vpc"
  }
}

module "test-subnet" {
  source            = "./modules/subnet"
  subnet_cidr_block = var.subnet_cidr_block
  env_prefix        = var.env_prefix
  vpc_id            = aws_vpc.test-vpc.id
}

module "test-server" {
  source              = "./modules/webserver"
  image_name          = var.image_name
  vpc_id              = aws_vpc.test-vpc.id
  my_ip               = var.my_ip
  env_prefix          = var.env_prefix
  instance_type       = var.instance_type
  subnet_id           = module.test-subnet.subnet.id
  public_key_location = var.public_key_location
  availability_zone = var.availability_zone
}

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