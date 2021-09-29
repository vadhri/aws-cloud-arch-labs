variable "region" {
  type    = string
  default = "XXXXXX"
}

source "amazon-ebs" "webservice-image" {
  ami_name      = "webservice-2"
  instance_type = "t2.micro"
  region        = "XXXXXX"
  subnet_id     = "XXXXXX" ## replace with a real subnet id.
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-*gp2"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username = "ec2-user"
}

# a build block invokes sources and runs provisioning steps on them.
build {
  sources = ["source.amazon-ebs.webservice-image"]

  provisioner "file" {
    source      = "./upload_files/docker_config.json"
    destination = "/tmp/config.json"
  }  

  provisioner "file" {
    source      = "./upload_files/aws_cred"
    destination = "/tmp/credentials"
  }  

  provisioner "file" {
    source      = "./upload_files/aws_config"
    destination = "/tmp/config"
  }  

  provisioner "file" {
    source = "./upload_files/ec2-init-service.sh"
    destination = "/tmp/rc.local"
  }

  provisioner "shell" {
    script = "./scripts.sh"
  }
}
