resource "aws_route53_zone" "primary" {
  name = var.zone_primary
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.cname_record_name
  type    = "CNAME"
  ttl     = 300
  records = [var.cname_record_value]
}