resource "aws_route53_zone" "primary" {
  name = "maracuyacotech.com.co"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www2.maracuyacotech.com.co"
  type    = "CNAME"
  ttl     = 300
  records = [""]
}