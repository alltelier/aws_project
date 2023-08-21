provider "aws" {
  region = "ap-northeast-2"
}


#로드밸런서 생성 
resource "aws_lb" "project04-lb" {
	name			= "project04-lb"
	load_balancer_type	= "application"
#로드밸런스 생성되는 vpc의 서브넷 
	subnets			= ["subnet-07520d03716ae0e01","subnet-0b6b4369668ab5265"]
#로드밸런스에 사용할 보안 그룹들 
	security_groups		= [data.aws_security_group.project04_web_sg.id,data.aws_security_group.project04_alb_sg.id]
} 



#ALB 리스너 - HTTP:80
resource "aws_lb_listener" "http" {
  load_balancer_arn	= aws_lb.project04-lb.arn
  port				= 80
  protocol			= "HTTP"

  default_action {
    type			= "forward"
    target_group_arn= aws_lb_target_group.asg.arn
  } 

}
#로드밸런서 리스너 룰 구성
#resource "aws_lb_listener_rule" "HTTP80" {
#	listener_arn	= aws_lb_listener.http.arn
#	priority		= 100
#
#	condition {
#		path_pattern {
#			values	= ["*"]
#		}
# }
#
#	action {
#		type				= "forward"
#		target_group_arn	= aws_lb_target_group.asg.arn
#		}
#}


#ALB 리스너 HTTP:8080
resource "aws_lb_listener" "asg-jenkins" {
  load_balancer_arn = aws_lb.project04-lb.arn
  port				= 8080
  protocol			= "HTTP"

  default_action {
    type            = "forward"
    target_group_arn= aws_lb_target_group.asg-jenkins.arn
  } 

}
#로드밸런서 리스너 룰 구성
#resource "aws_lb_listener_rule" "HTTP8080" {
#	listener_arn	= aws_lb_listener.http.arn
#	priority		= 100
#
#	condition {
#		path_pattern {
#			values	= ["*"]
#		}
#	}

#	action {
#		type				= "forward"
#		target_group_arn	= aws_lb_target_group.asg-jenkins.arn
#		}
#}



#로드밸런서 대상그룹 
resource "aws_lb_target_group" "asg" {
	name	= "project04-target-group"
	port	= var.server_port
	protocol	= "HTTP"
	vpc_id		= data.aws_vpc.project04-vpc.id

	health_check {
		path		        = "/"
		protocol	        = "HTTP"
		matcher		        = "200"
		interval 	        = 15
		timeout		        = 3
		healthy_threshold	= 2
		unhealthy_threshold	= 2
	}	
}


resource "aws_lb_target_group" "asg-jenkins" {
  name        = "project04-target-group-jenkins"
  port        = var.server_port
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.project04-vpc.id

	health_check {
		path		        = "/"
		protocol	        = "HTTP"
		matcher		        = "200"
		interval 	        = 15
		timeout		        = 3
		healthy_threshold	= 2
		unhealthy_threshold	= 2
	}	
}


#정보 가져 오기
data "aws_vpc" "project04-vpc"  {
	id = "vpc-0ef5fd852b154d136"
}
data "aws_subnets" "project04-vpc" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.project04-vpc.id]
  }
}

data "aws_security_group" "project04_alb_sg" {
    id = "sg-0151c526c8195891f"
}

data "aws_security_group" "project04_web_sg" {
    id = "sg-04a9d5c5086565b93"
}

data "template_file" "web_output" {
	template = file("${path.module}/web.sh")
	vars = {
		server_port = "${var.server_port}"
	}
}

variable "server_port" {
  description = "The port will use for HTTP requests"
  type        = number
  default     = 8080
}
