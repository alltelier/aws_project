#시작템플릿 
resource "aws_launch_template" "project04-target-image" {
	name			      = "project04-launch-template"
	image_id        = data.terraform_remote_state.project04_target_ami.outputs.ami_id
  instance_type   = "t2.micro"
 	vpc_security_group_ids 	= [data.terraform_remote_state.project04_sg.outputs.project04_ssh,data.terraform_remote_state.project04_sg.outputs.project04_alb]
	key_name 				= "project04-key"

  iam_instance_profile {
      name = "project04-code-deploy-ec2-role"
  } 
  
  tags = {
    Name = "project04-code-deploy-instance"
  }
	
  lifecycle {
  create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "project04-target-group" {
 # availability_zones = ["ap-northeast-2a", "ap-northeast-2c"]
  vpc_zone_identifier = [data.terraform_remote_state.project04_vpc.outputs.private_subnet2a, data.terraform_remote_state.project04_vpc.outputs.private_subnet2c]

  name             = "project04-target-group"
  desired_capacity = 3
  min_size         = 3
  max_size         = 3

  target_group_arns = [data.aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  launch_template {
    id      = aws_launch_template.project04-target-image.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "project04-target-group"
    propagate_at_launch = true
  }
}

data "aws_lb_target_group" "asg" {
    arn = "-------"
}
