#create ACM certificate
resource "aws_acm_certificate" "ssl_certificate" {
  # This resource creates an SSL certificate using AWS Certificate Manager (ACM).
  # The certificate is created for the specified domain name and its subject alternative names.
  # The validation method is set to DNS, which means that the certificate will be validated using DNS records.
  domain_name               = var.domain_name
  subject_alternative_names = ["www.${var.domain_name}"]
  validation_method         = "DNS"


  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "Jupiter SSL Certificate"
  }
}

#create DNS record for ACM certificate validation
resource "aws_route53_record" "ssl_certificate_validation" {
  for_each = {
    for dvo in aws_acm_certificate.ssl_certificate : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 300
  type            = each.value.type
  zone_id         = data.aws_route53_zone.main.zone_id
}

# Wait for the certificate to be validated
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.ssl.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

