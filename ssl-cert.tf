resource "aws_acm_certificate" "default" {
  domain_name       = "*.clusters.khaledemara.dev"
  validation_method = "DNS"
}

data "aws_route53_zone" "external" {
  name         = "clusters.khaledemara.dev"
  private_zone = false
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.default.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.external.zone_id
}

resource "aws_acm_certificate_validation" "default" {
  certificate_arn = aws_acm_certificate.default.arn
  validation_record_fqdns = [
    for record in aws_route53_record.validation : record.fqdn
  ]
}

resource "aws_route53_record" "alb-record" {
  zone_id = data.aws_route53_zone.external.zone_id
  name    = "test3.${data.aws_route53_zone.external.name}"
  type    = "A"
  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = false
  }
}
