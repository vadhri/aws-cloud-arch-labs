resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

resource "aws_route53_record" "primary" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    evaluate_target_health = true
    name = aws_cloudfront_distribution.clf.domain_name
    zone_id = aws_cloudfront_distribution.clf.hosted_zone_id
  }
}

resource "aws_route53_record" "primary_with_www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name_alt1
  type    = "A"

  alias {
    evaluate_target_health = true
    name = aws_cloudfront_distribution.clf.domain_name
    zone_id = aws_cloudfront_distribution.clf.hosted_zone_id
  }  
}