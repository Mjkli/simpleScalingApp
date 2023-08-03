resource "aws_launch_template" "api_template" {
    name_prefix = "saa-api"
    image_id = "ami-04d1dcfb793f6fa37"
    instance_type = "t2.micro"

    network_interfaces {
      associate_public_ip_address = false
    }

}

resource "aws_autoscaling_group" "api_asg" {
    name = "apiASG"
    desired_capacity = 1
    min_size = 1
    max_size = 3
    force_delete = true
    vpc_zone_identifier = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
    target_group_arns = [aws_lb_target_group.lb_tg.arn]

    launch_template {
        id = aws_launch_template.api_template.id
        version = "$Latest"
    }
}

resource "aws_autoscaling_attachment" "asg_attach" {
    autoscaling_group_name = aws_autoscaling_group.api_asg.name
    lb_target_group_arn = aws_lb_target_group.lb_tg.arn
}