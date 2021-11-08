provider "aws" {
 region = "us-east-2"
}
variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}
variable ssh_key {}
variable instance_type {}
variable public_key_location   {}

resource "aws_vpc" "pwdemo-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = { 
      Name: "${var.env_prefix}-vpc"
  }
}  

resource "aws_subnet" "pwdemo-subnet-1" {
  vpc_id = aws_vpc.pwdemo-vpc.id  
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = { 
      Name: "${var.env_prefix}-subnet-1"
  }
}  

resource "aws_route_table" "pwdemo-route-table" {
    vpc_id = aws_vpc.pwdemo-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.pwdemo-igw.id
    }
    tags = {
        Name: "${var.env_prefix}-rtb"
    }
}

resource "aws_internet_gateway" "pwdemo-igw" {
    vpc_id = aws_vpc.pwdemo-vpc.id
    tags = {
        Name: "${var.env_prefix}-igw"
    }    
}

resource "aws_route_table_association" "a-rtb-subnet" {
    subnet_id = aws_subnet.pwdemo-subnet-1.id
    route_table_id = aws_route_table.pwdemo-route-table.id
}

resource "aws_security_group" "pwdemo-sg" {
  name = "pwdemo-sg"
  vpc_id = aws_vpc.pwdemo-vpc.id

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  } 

  ingress {
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }    

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      prefix_list_ids = [] 
  }
  
  tags = {
      Name: "${var.env_prefix}-sg"
  } 
}

## data "aws_ami" "latest-amazon-linux-image" {
##    filter {
##    name = "name"
##      values = ["amzn2-ami-hvm-*-x86_64-gp2"]
##    filter {
  ##    name = "virtualization-type"
  ##    values = ["hvm"]
    ##}   
##}

resource "aws_key_pair" "ssh-key"{
    key_name = "server-key-pair"
    public_key = file(var.public_key_location)
}

resource "aws_instance" "pwdemo_server" {
    ami = "ami-0f19d220602031aed"
    instance_type = var.instance_type

    subnet_id = aws_subnet.pwdemo-subnet-1.id
    vpc_security_group_ids = [aws_security_group.pwdemo-sg.id]
    availability_zone = var.avail_zone
   
    associate_public_ip_address = true 
    key_name = "aws_key_pair.ssh-key.key_name"

    tags = {
      Name = "${var.env_prefix}-server"
    }
}