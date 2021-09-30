resource "aws_service_discovery_service" "servicediscovery" {
  name = "service-discovery"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.internal.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_private_dns_namespace" "internal" {
  name        = "internal"
  description = "internal"
  vpc         = aws_vpc.region_vpc.id
}
