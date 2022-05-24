provider "aws" {
  access_key = var.lab_access_key
  secret_key = var.lab_secret_key
  token      = var.lab_token
  region     = var.lab_region
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "CCWEBSERVER"
  public_key = file("files/keypair.pem")
}




