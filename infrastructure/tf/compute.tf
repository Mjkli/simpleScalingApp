resource "aws_launch_template" "api_template" {
    name_prefix = "saa-api"
    image_id = "ami-04d1dcfb793f6fa37"
    instance_type = "t2.micro"
}


resource "aws_autoscaling_group" "api_asg" {
    availability_zones = ["us-west-1a"]
    desired_capacity = 1
    min_size = 1
    max_size = 3

    launch_template {
        id = aws_launch_template.api_template.id
        version = "$Latest"
    }

}

resource "aws_autoscaling_attachment" "asg_attach" {
    autoscaling_group_name = aws_autoscaling_group.api_asg.name
    lb_target_group_arn = aws_lb_target_group.lb_tg.arn
}