resource aws_security_group "Security-Group" {
    name = "public_sbunet_sg"
    vpc_id = aws_vpc.region_vpc.id 

    ingress = [ {
      cidr_blocks = [ "0.0.0.0/0"]
      description = "incoming traffic"
      from_port = 22
      ipv6_cidr_blocks = ["::/0"]        
      protocol = "tcp"
      prefix_list_ids = []
      security_groups = []
      self = false
      to_port = 22
    } ]

    egress = [ {
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]        
      description = "Allow outgoing internet"
      from_port = 0
      protocol = -1
      prefix_list_ids = []
      security_groups = []
      self = false      
      to_port = 0
    } ]
}