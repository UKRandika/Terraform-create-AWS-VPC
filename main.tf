terraform{
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~>3.0"
      }
    }
}

#configure the aws provider
#Enter your AWS credinitials using AWS CLI
provider "aws" {

    region = "us-east-1"
  
}

#Create a VPC

resource "aws_vpc" "MyLab-VPC" {
    cidr_block = var.cidr_block[0]
    tags = {
      "Name" = "MyLab-VPC"
    }
}

#Create Subnet (public)

resource "aws_subnet" "MyLab-Subnet1" {

    vpc_id = aws_vpc.MyLab-VPC.id
    cidr_block = var.cidr_block[1]

    tags = {
      "Name" = "MyLab-Subnet1"
    }
  
}

#Create Internet Gateway

resource "aws_internet_gateway" "MyLab-IntGw" {

    vpc_id = aws_vpc.MyLab-VPC.id

    tags = {
      "Name" = "MyLab-InternetGW"
    }
  
}

#Create Security Group

resource "aws_security_group" "MyLab_SecurityGroup" {
    name = "MyLab Security Group"
    description = "To allow inbound and outbound traffic to mylab"
    vpc_id = aws_vpc.MyLab-VPC.id

    ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]  
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    },
  {
      description      = "HTTPS"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]  
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false      
  },

    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]  
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false      
    }
  ]


  egress = [
    {
      description      = "for all outgoing traffics"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]

    tags = {
      "Name" = "allow traffic"
    }
}