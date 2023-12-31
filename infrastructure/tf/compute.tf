
data "aws_ami" "image" {
  most_recent = true
  owners = ["181066809772"]
  name_regex = "ssa api *"

}



resource "aws_launch_template" "api_template" {
    name_prefix = "saa-api"
    image_id = "${data.aws_ami.image.id}"
    instance_type = "t2.micro"
    update_default_version = true
    key_name = "main"


    network_interfaces {
      associate_public_ip_address = false
      security_groups = ["${aws_security_group.allow_lb.id}"]
    }

    user_data = filebase64("${path.module}/api.sh")

}

resource "aws_autoscaling_group" "api_asg" {
    name = "apiASG"
    desired_capacity = 1
    min_size = 1
    max_size = 3
    vpc_zone_identifier = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
    target_group_arns = [aws_lb_target_group.lb_tg.arn]

    launch_template {
        id = aws_launch_template.api_template.id
        version = "$Latest"
    }

    lifecycle {
      create_before_destroy = true
    }
}

# This is how the load balancer sends traffic to proper ec2 instances
resource "aws_autoscaling_attachment" "asg_attach" {
    autoscaling_group_name = aws_autoscaling_group.api_asg.name
    lb_target_group_arn = aws_lb_target_group.lb_tg.arn
}