resource "aws_route53_zone" "primary" {
  name = "XXXXX"
}

resource "aws_route53_record" "primary" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "XXXXX"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.alb-elastic-ip.public_ip]
}

resource "aws_route53_record" "primary_with_www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "XXXXX"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.alb-elastic-ip.public_ip]
}