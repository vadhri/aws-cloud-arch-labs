resource "aws_route53_zone" "primary" {
  name = "######"
}

resource "aws_route53_record" "primary" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = ""######""
  type    = "A"

  alias {
    evaluate_target_health = true
    name = aws_lb.webserver_lb.dns_name
    zone_id = aws_lb.webserver_lb.zone_id
  }
}

resource "aws_route53_record" "primary_with_www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = ""######""
  type    = "A"

  alias {
    evaluate_target_health = true
    name = aws_lb.webserver_lb.dns_name
    zone_id = aws_lb.webserver_lb.zone_id
  }  
}