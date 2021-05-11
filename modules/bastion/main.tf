data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = [var.ami_data]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource"aws_instance" "test-bastion" {
    ami = data.aws_ami.latest-amazon-linux-image.id
    instance_type = var.instance_type
    
    tags = merge(
      var.env_prefix,
      tomap({"Name"="${terraform.workspace}-bastion-server"})
    )
}