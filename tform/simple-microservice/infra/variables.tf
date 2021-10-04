variable "region" {
    description = "Enter the region name"
    type = string
    default = "XXXXXXXXXX"
}

variable "az1" {
    description = "Enter the availability zone 1"
    type = string
    default = "XXXXXXXXXX"
}

variable "az2" {
    description = "Enter the availability zone 2"
    type = string
    default = "XXXXXXXXXX"
}

variable "db_az1" {
    description = "Enter the availability zone 1"
    type = string
    default = "XXXXXXXXXX"
}

variable "db_az2" {
    description = "Enter the availability zone 2"
    type = string
    default = "XXXXXXXXXX"
}


variable "ami_key_pair_name" {
    description = "Enter the key pair name"
    type = string 
    default = "XXXXXXXXXX"
}

variable "acm_cert_arn" {
  description = "ACM certificate"
  type = string
  default = "XXXXXXXXXX"
}

variable "domain_name" {
    description = "domain name"
    type = string
    default = "XXXXXXXXXX"
}

variable "domain_name_alt1" {
    description = "alternate sub-domain name"
    type = string
    default = "XXXXXXXXXX"
}

variable "db_username" {
  type = string
  default = "XXXXXXXXXX"
}

variable "db_password" {
  type = string
  default = "XXXXXXXXXX"
}

variable "db_port" {
  type = string
  default = "XXXXXXXXXX"
}

variable "internal_domain_name" {
  type = string
  default = "XXXXXXXXXX"
}

variable "db_service_container_image" {
    type = string
    default = "XXXXXXXXXX"
}

variable "frontend_service_container_image" {
    type = string
    default = "XXXXXXXXXX"
}