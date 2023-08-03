resource "aws_security_group" "allow_http"{
    name = "allow_http"
    description = "Allows public access to the loadbalancer"
    vpc_id = aws_vpc.main-vpc.id

    ingress {
        description = "HTTP from VPC"
        from_port = 80
        to_port = 80
        protocol = "http"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_http"
        project = "simpleScalingApp"
    }
}