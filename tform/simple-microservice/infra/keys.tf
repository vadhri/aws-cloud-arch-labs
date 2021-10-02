resource "tls_private_key" "pvtkey" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "generated_key_pair" {
  key_name = "aws_ec2_key_pair"
  public_key = tls_private_key.pvtkey.public_key_openssh

  provisioner "local-exec" { 
    command = "echo '${tls_private_key.pvtkey.private_key_pem}' > ./ec-access.pem"
  }
}
