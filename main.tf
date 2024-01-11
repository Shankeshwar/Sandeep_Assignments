provider "aws" {
    region = "us-east-1"
  
}

module "ec2_instance" {
    source = "./modules/ec2_instance"
  vpc_cidr       = "10.0.0.0/16"
  ami_id        = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  sn_01_cidr    = "10.0.0.0/17"
  sn_02_cidr    = "10.0.128.0/17"
  allow_tls     = "0.0.0.0/0"
  rt_cidr       = "0.0.0.0/0"
  egress        = [0]
  ingress       = [22,8080]
  key_name = "NVirginia_aws"
  #key_path      = "./private_key.pem"
    
}