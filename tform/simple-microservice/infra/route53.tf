resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

resource "aws_route53_zone" "service_tcp_local" {
  name = var.internal_domain_name
  vpc {
    vpc_id = aws_vpc.region_vpc.id
  }  
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
resource "aws_route53_record" "records_service_tcp_local" {
  zone_id = aws_route53_zone.service_tcp_local.zone_id
  name    = "rdsdbservice"
  type    = "CNAME"
  ttl     = "5"

  weighted_routing_policy {
    weight = 100
  }
  set_identifier = "db-rds"
  records        = [aws_db_instance.Rds-Db.address]
}

resource "aws_route53_record" "replica_records_service_tcp_local" {
  zone_id = aws_route53_zone.service_tcp_local.zone_id
  name    = "rdsreplicadbservice"
  type    = "CNAME"
  ttl     = "5"

  weighted_routing_policy {
    weight = 100
  }
  set_identifier = "db-rds-replica"
  records        = [aws_db_instance.Rds-Db-Replica.address]
}