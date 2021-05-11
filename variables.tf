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
variable "db_username" {}
variable "db_password" {}

variable "project" {
  default = "Terraform"
}

variable "snapshot" {
  default = true
}