resource "aws_instance" "bastion" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = "utc-key"
  subnet_id     = module.vpc.public_subnets[0]

  associate_public_ip_address = true # Assign a public IP

  vpc_security_group_ids = [aws_security_group.bastion_host_sg.id]

  tags = {
    Name = "Bastion Host"
    env  = "dev"
    team = "config management"
  }
}

resource "aws_instance" "app_server" {
  count         = 2
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI  # Replace with your AMI ID
  instance_type = "t2.micro"
  key_name      = "utc-key"
  subnet_id     = module.vpc.private_subnets[count.index % length(module.vpc.private_subnets)]

  vpc_security_group_ids = [aws_security_group.app_server_sg.id] # Use SG ID instead of name


  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd.x86_64
              systemctl start httpd.service
              systemctl enable httpd.service
              echo "Hello World from $(hostname -f)" > /var/www/html/index.html
              EOF

  tags = {
    Name = "app-server-${count.index + 1}"
    env  = "dev"
    team = "config management"
  }
}
