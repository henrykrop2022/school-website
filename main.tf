module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  #version = "x.x.x"  # Use the desired module version

  name = "utc-vpc"
  cidr = "10.10.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets  = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  private_subnets = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true  # Use a single NAT Gateway
  #enable_s3_endpoint = true

  tags = {
    Name = "utc-vpc"
    env  = "dev"
    team = "config management"
  }
}


# Key pair 
resource "tls_private_key" "tls" {
  algorithm = "RSA"
  rsa_bits = 2048
}
resource "aws_key_pair" "utc_key" {
  key_name = "utc-key"
  public_key = tls_private_key.tls.public_key_openssh
}
resource "local_file" "utc_key1" {
  filename = "utc-key.pem"
  content = tls_private_key.tls.private_key_pem
}

