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

variable "ami_key_pair_name" {
    description = "Enter the key pair name"
    type = string 
    default = "ec-access"
}
