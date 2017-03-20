provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "eu-west-1"
}



resource "aws_instance" "app" {
    ami = "ami-0451d977"
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