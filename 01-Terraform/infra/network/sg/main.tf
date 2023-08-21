
#SSH Security group
resource "aws_security_group" "project04_ssh_sg" {
    name   = "Project04 SSH Accept"
    description = "security group for ssh server"
    vpc_id = data.terraform_remote_state.project04_vpc.outputs.vpc_id


    ingress {
        description = "For SSH accept"
        protocol    = "tcp"
        from_port   = 22
        to_port     = 22
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "Project04 SSH Accept"
        Description = "for SSH accept"
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


#WEB Security group - HTTP 80, 443
resource "aws_security_group" "project04_web_sg_https" {
    name        = "Project04 WEB Accept-HTTPS"
    description = "sg for HTTP accept"
    vpc_id      = data.terraform_remote_state.project04_vpc.outputs.vpc_id


    ingress {
        description = "For WEB port"
        protocol    = "tcp"
        from_port   = 80
        to_port     = 80
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "For WEB port"
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "Project04 WEB Accept-HTTPS"
        Description = "sg for HTTP accept"
    }
}

