variable "region" {
    description = "Enter the region name"
    type = string
    default = "us-east-1"
}

variable "az1" {
    description = "Enter the availability zone 1"
    type = string
    default = "us-east-1a"
}

variable "az2" {
    description = "Enter the availability zone 2"
    type = string
    default = "us-east-1b"
}

variable "db_az1" {
    description = "Enter the availability zone 1"
    type = string
    default = "us-east-1e"
}

variable "db_az2" {
    description = "Enter the availability zone 2"
    type = string
    default = "us-east-1f"
}


variable "ami_key_pair_name" {
    description = "Enter the key pair name"
    type = string 
    default = "ec-access"
}

variable "acm_cert_arn" {
  description = "ACM certificate"
  type = string
  default = "XXXX"
}

variable "domain_name" {
    description = "domain name"
    type = string
    default = "XXXX"
}

variable "domain_name_alt1" {
    description = "alternate sub-domain name"
    type = string
    default = "XXXX"
}

variable "db_username" {
  type = string
  default = "XXXX"
}

variable "db_password" {
  type = string
  default = "XXXXX"
}

variable "db_port" {
  type = string
  default = "3306"
}

variable "internal_domain_name" {
  type = string
  default = "service._tcp.local"
}

variable "db_service_container_image" {
    type = string
    default = "ami-XXXX"
}

variable "frontend_service_container_image" {
    type = string
    default = "ami-XXXX"
}