resource "aws_cloudfront_distribution" "clf" {
    enabled = true
    aliases = [var.domain_name, var.domain_name_alt1]
    
    viewer_certificate {
        acm_certificate_arn = var.acm_cert_arn
        cloudfront_default_certificate = true
        ssl_support_method = "sni-only"
    }

    default_cache_behavior {
        allowed_methods =  ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods = ["GET", "HEAD"]
        target_origin_id = aws_lb.webserver_lb.id
        viewer_protocol_policy = "allow-all"
        forwarded_values {
            query_string = true

            cookies {
                forward = "none"
            }
        }      
    }

    origin {
        domain_name = aws_lb.webserver_lb.dns_name
        origin_id = aws_lb.webserver_lb.id
        custom_origin_config {
            http_port = "8080"
            https_port = "443"
            origin_protocol_policy = "http-only"
            origin_ssl_protocols = ["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"]
        }
    }
        
    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }    
}