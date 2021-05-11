variable "vpc_cidr_block" {
  description = "cidr blocks for vpc and subnets"
  # type = list(object({
  #   cidr_block = string,
  #   name = string
  # })
  # )
}
variable "subnet_cidr_block_public_a" {
  description = "cidr blocks for vpc and subnets"
  # type = list(object({
  #   cidr_block = string,
  #   name = string
  # })
  # )
}
variable "subnet_cidr_block_public_b" {}
variable "subnet_cidr_block_private_a" {}
variable "subnet_cidr_block_private_b" {}
# variable "availability_zone" {}
# variable "my_ip" {}
# variable "instance_type" {}
# variable "public_key_location" {}
# variable "entry_script_location" {}
# variable "image_name" {}
# variable "access_key" {}
# variable "secret_key" {}
# variable "token" {}
variable "project" {
  default = "Terraform"
}

variable "snapshot" {
  default = true
}