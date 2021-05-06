output "ec2-public-ip" {
  value = aws_instance.test-server.public_ip
}