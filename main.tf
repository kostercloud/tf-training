

provider "aws" {
  access_key = "AKIAXMT4EY5DMRUP4AHF"
  secret_key = "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"
  region     = "us-east-1"
}

variable "servers" {
  description = "Map of server types to configuration"
  type        = map(any)
  default = {
    server-iis = {
      ami                    = "ami-09943f9da1f1b7899"
      instance_type          = "t2.micro",
      environment            = "dev"
      subnet_id              = "subnet-061226b4287f571c3"
      vpc_security_group_ids = ["sg-0cf3d1190f348f5e5"]
    },
    server-apache = {
      ami                    = "ami-09943f9da1f1b7899"
      instance_type          = "t2.micro",
      environment            = "test"
      subnet_id              = "subnet-061226b4287f571c3"
      vpc_security_group_ids = ["sg-0cf3d1190f348f5e5"]
    }
  }
}

resource "aws_instance" "web" {
  for_each               = var.servers
  ami                    = each.value.ami
  instance_type          = each.value.instance_type
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = each.value.vpc_security_group_ids

  tags = {
    "Identity"    = "terraform-nyl-bear"
    "Training"    = "yes"
    "Name"        = each.key
    "Environment" = each.value.environment
  }
}

module "keypair" {
  source  = "mitchellh/dynamic-keys/aws"
  version = "2.0.0"
  path    = "${path.root}/keys"
  name    = "terraform-nyl-bear-key"
}