provider "aws" {
    region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "anddevops"
    key    = "state"
    region = "eu-west-1"
  }
}

resource "aws_instance" "app" {
    ami = "ami-405f7226"
    count=2
    instance_type = "t2.micro"
    security_groups = ["chris-sec-group"]

    tags {
        Name = "Instance Created by Terraform - Number ${count.index}"
    }
}

output "ips" {
    value = "${join(",", aws_instance.app.*.public_ip)}"
}