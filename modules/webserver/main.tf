resource "aws_security_group" "test-sg" {
  name   = "test-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.env_prefix}-sg"
  }
}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = [var.image_name]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_key_pair" "test-ssh-key" {
  key_name   = "test-ssh-key"
  public_key = file(var.public_key_location)
}

resource "aws_instance" "test-server" {
  ami           = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.test-sg.id]
  availability_zone      = "us-east-1a"

  associate_public_ip_address = true
  key_name                    = aws_key_pair.test-ssh-key.key_name

  user_data = file("entry-docker-script.sh")

  #Another way to run shell script
  # provisioner "remote-exec" {
  #   script = file("entry-docker-script.sh")
  # }
  # provisioner "file" {
  #   source = "entry-docker-script.sh"
  #   destination = var.entry_script_location
  # }  
  # connection {
  #   type = "ssh"
  #   host = self.public_ip
  #   user = "ec2-user"
  #   private_key = file(var.private_key_location)
  # }


  tags = {
    Name = "${var.env_prefix}-server"
  }

}