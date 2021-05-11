resource "aws_db_subnet_group" "main" {
    name = "${terraform.workspace}-main"
    subnet_ids = [
        var.subnet_private_a,
        var.subnet_private_b
    ]

    tags = {
    Name : "${terraform.workspace}-main"
  }
}

resource "aws_security_group" "rds" {
    name = "${terraform.workspace}-rds-sg"
    vpc_id = var.vpc_id

    ingress {
        protocol = "tcp"
        from_port = 5432
        to_port = 5432
    }

    tags = var.env_prefix
}