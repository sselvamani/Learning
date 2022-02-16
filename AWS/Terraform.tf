\ stared Learning 

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "single-instance"

  ami                    = " ami-086be6d514a32d0f4"
  instance_type          = "t2.micro"
  key_name               = "user1"
  monitoring             = true
  vpc_security_group_ids = ["sg-06936e6a9e1055f0d"]
  subnet_id              = "subnet-0217fb2dff66cc424"

  tags = {
    Terraform   = "true" ""
    Environment = "dev"
  }
}
