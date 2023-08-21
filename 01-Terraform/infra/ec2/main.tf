resource "aws_instance" "project04-jenkins" {
    ami = data.aws_ami.ubuntu.image_id
    instance_type = "t3.large"
    key_name = "project04-key"

	 #보안 그룹
    vpc_security_group_ids = [aws_security_group.project04_ssh_sg.id, aws_security_group.project04_web_sg_http.id] 

	#서브넷
    subnet_id = data.terraform_remote_state.project04_vpc.outputs.private_subnet2a
    ##subnet_id = aws_subnet.project04_private_subnet2a.id
    #subnet_id = subnet-025a662567c217d0d

	#가용 영역
    availability_zone = "ap-northeast-2a"

	# 퍼블릭 IP 할당 여부
    # associate_public_ip_address = true

    tags = {
        Name = "project04-jenkins"
    }
}

#resource "aws_eip" "elasticip" {
#    instance = aws_instance.project04-jenkins.id
#}

#output "EIP" {
#    value = aws_eip.elasticip.public_ip
#}

#SSH Security group
resource "aws_security_group" "project04_ssh_sg" {
    name        = "project04_ssh_sg"
    description = "security group for ssh server"
    vpc_id      = data.terraform_remote_state.project04_vpc.outputs.vpc_id

    ingress {
        description = "For ssh port"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "project04_ssh_sg"
		Description = "SSH security group"
    }
}

#WEB Security group - HTTP 8080
resource "aws_security_group" "project04_web_sg_http" {
    name        = "Project04 WEB Accept-HTTP"
    description = "sg for HTTP accept"
    vpc_id      = data.terraform_remote_state.project04_vpc.outputs.vpc_id


    ingress {
        description = "For WEB port"
        protocol    = "tcp"
        from_port   = 8080
        to_port     = 8080
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "Project04 WEB Accept-HTTP"
        Description = "sg for HTTP accept"
    }
}