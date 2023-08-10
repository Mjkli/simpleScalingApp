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

resource "aws_route_table" "vpc_rt" {
    vpc_id = aws_vpc.main-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.main-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.asg_ngw.id
    }
}

resource "aws_eip" "nat_gw_ip" {
    domain = "vpc"
}

resource "aws_nat_gateway" "asg_ngw" {
    subnet_id = aws_subnet.public-subnet-1.id
    allocation_id = aws_eip.nat_gw_ip.id
}

resource "aws_subnet" "public-subnet-1"{
    vpc_id = aws_vpc.main-vpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-west-1a"

    tags = {
        Name = "public-subnet-1"
        project = "simpleScalingApp"
    }
}

resource "aws_subnet" "public-subnet-2"{
    vpc_id = aws_vpc.main-vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-west-1a"

    tags = {
        Name = "public-subnet-1"
        project = "simpleScalingApp"
    }
}

resource "aws_subnet" "private-subnet-1" {
    vpc_id = aws_vpc.main-vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-west-1a"

    tags = {
        Name = "private-subnet-1"
        project = "simpleScalingApp"
    }
}

resource "aws_subnet" "private-subnet-2" {
    vpc_id = aws_vpc.main-vpc.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-west-1b"

    tags = {
        Name = "private-subnet-2"
        project = "simpleScalingApp"
    }
}

resource "aws_route_table_association" "rt_public_sub1" {
    subnet_id = aws_subnet.public-subnet-1.id
    route_table_id = aws_route_table.vpc_rt.id
}

resource "aws_route_table_association" "rt_public_sub2" {
    subnet_id = aws_subnet.public-subnet-2.id
    route_table_id = aws_route_table.vpc_rt.id
}

resource "aws_route_table_association" "rt_private_sub1" {
    subnet_id = aws_subnet.private-subnet-1.id
    route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "rt_private_sub2" {
    subnet_id = aws_subnet.private-subnet-2.id
    route_table_id = aws_route_table.private_rt.id
}

resource "aws_lb" "main_lb" {
    name = "ssaLB"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.allow_http.id]
    subnets = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]

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
    port = 80
    protocol = "HTTP"

    default_action{
        type = "forward"
        target_group_arn = aws_lb_target_group.lb_tg.arn
    }

}

resource "aws_lb_target_group" "lb_tg" {
    name = "ssaLBtg"
    port = "8000"
    protocol = "HTTP"
    vpc_id = aws_vpc.main-vpc.id

}
