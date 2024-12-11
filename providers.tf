terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80.0"  # Use a compatible version
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.6"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.3"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "default"
}