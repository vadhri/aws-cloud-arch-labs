resource "aws_security_group" "security" {
    name = "allow_80_8080_22_443"
    vpc_id = "${aws_vpc.region_vpc.id}"
    
    ingress {
        cidr_blocks = ["0.0.0.0/0"]

        from_port = 22
        to_port = 22
        protocol = "tcp"
    }

    ingress {
        cidr_blocks = ["0.0.0.0/0"]

        from_port = 8080
        to_port = 8080
        protocol = "tcp"
    }

    ingress {
        cidr_blocks = ["0.0.0.0/0"]

        from_port = 443
        to_port = 443
        protocol = "tcp"
    }

    ingress {
        cidr_blocks = ["0.0.0.0/0"]

        from_port = 80
        to_port = 80
        protocol = "tcp"
    }

    ingress {
        cidr_blocks = ["0.0.0.0/0"]

        from_port = 8
        to_port = 0

        protocol = "icmp"
    }

    ingress {
        cidr_blocks = ["0.0.0.0/0"]

        from_port = 3306
        to_port = 3306

        protocol = "tcp"
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
