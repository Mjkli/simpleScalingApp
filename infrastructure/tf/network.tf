resource "aws_vpc" "main-vpc" {
    cidr_block = "10.0.0.0/16"


    tags = {
        Name = "main"
        project = "simpleScalingApp"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main-vpc.id
}



resource "aws_subnet" "subnet-1" {
    vpc_id = aws_vpc.main-vpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-west-1a"

    tags = {
        Name = "subnet-1"
        project = "simpleScalingApp"
    }
}

resource "aws_subnet" "subnet-2" {
    vpc_id = aws_vpc.main-vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-west-1b"

    tags = {
        Name = "subnet-2"
        project = "simpleScalingApp"
    }
}

resource "aws_lb" "main_lb" {
    name = "ssaLB"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.allow_http.id]
    subnets = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]

    tags = {
        Name = "main_lb"
        project = "simpleScalingApp"
    }

    timeouts {
      create = "30m"
    }
}

resource "aws_lb_listener" "lb_listener" {
    load_balancer_arn = aws_lb.main_lb.arn
    port = 8000
    protocol = "TCP"

    default_action{
        type = "forward"
        target_group_arn = aws_lb_target_group.lb_tg.arn
    }

}

resource "aws_lb_target_group" "lb_tg" {
    name = "ssaLBtg"
    port = "8000"
    protocol = "TCP"
    vpc_id = aws_vpc.main-vpc.id

}
