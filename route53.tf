/*# Data source to get the existing hosted zone details
data "aws_route53_zone" "existing_zone" {
  name = "learn-4.com."  # Full domain name with a trailing dot
}

# Define your ALB
resource "aws_lb" "alb_for_route53" {
  name               = "utc-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets

  tags = {
    Name = "utc-alb"
    env  = "dev"
    team = "config management"
  }
}

# Create an Alias Record for the subdomain pointing to the renamed ALB
resource "aws_route53_record" "learning_subdomain_alias" {
  zone_id = data.aws_route53_zone.existing_zone.id
  name    = "learning.learn-4.com"  # Subdomain
  type    = "A"  # Alias record type

  alias {
    name                   = aws_lb.alb_for_route53.dns_name  # Renamed ALB DNS name
    zone_id                = aws_lb.alb_for_route53.zone_id  # Renamed ALB Hosted Zone ID
    evaluate_target_health = true  # Optional: Checks if the ALB target is healthy
  }
}

# Certificate validation (for SSL cert)
resource "aws_route53_record" "cert_validation" {
  for_each = { for d in aws_acm_certificate.cert.domain_validation_options : d.domain_name => d }
  zone_id  = data.aws_route53_zone.existing_zone.id  # Correct reference
  name     = each.value.resource_record_name
  type     = each.value.resource_record_type
  records  = [each.value.resource_record_value]
  ttl      = 300
}

# SSL Certificate via ACM (Optional)
resource "aws_acm_certificate" "cert" {
  domain_name       = "learning.learn-4.com" # Subdomain
  validation_method = "DNS"

  tags = {
    Name = "ssl-cert-learning"
    env  = "dev"
  }
}


resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
*///