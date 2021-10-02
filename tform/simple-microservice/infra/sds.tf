resource "aws_service_discovery_private_dns_namespace" "internal" {
  name        = "internal"
  description = "internal"
  vpc         = aws_vpc.region_vpc.id
}

resource "aws_service_discovery_service" "Web-Service-Discovery" {
  name = "webservice"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.internal.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "WEIGHTED"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_instance" "service-discovery-web-service" {
  instance_id = "web-server-instance-id"
  service_id  = aws_service_discovery_service.Web-Service-Discovery.id

  attributes = {
    AWS_ALIAS_DNS_NAME = aws_lb.webserver_lb.dns_name
  }
}

resource "aws_service_discovery_service" "Db-Service-Discovery" {
  name = "dbservice"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.internal.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "WEIGHTED"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_instance" "service-discovery-db-service" {
  instance_id = "db-server-instance-id"
  service_id  = aws_service_discovery_service.Db-Service-Discovery.id

  attributes = {
    AWS_ALIAS_DNS_NAME = aws_lb.dbserver_lb.dns_name
  }
}