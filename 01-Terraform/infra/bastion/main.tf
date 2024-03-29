resource "aws_instance" "project04_bastion" {
    ami = data.aws_ami.ubuntu.image_id
    instance_type = "t2.micro"
    key_name = "project04-key"
    #보안 그룹
    vpc_security_group_ids = [aws_security_group.project04_ssh_sg.id]
    #서브넷 
    subnet_id = data.terraform_remote_state.project04_vpc.outputs.public_subnet2a
    #가용 영역
    availability_zone = "ap-northeast-2a"
    #퍼블릭 IP 할당 여부 
    associate_public_ip_address = true

    tags = {
        Name = "project04-bastion"
    }
}


???보안그룹???
resource "aws_security_group" "project04_ssh_sg" {
    name   = "project04_ssh_sg"
    description = "security group for ssh server"
    vpc_id = data.terraform_remote_state.aws04_vpc.outputs.vpc_id


    ingress {
        description = "For SSH port"
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
        Name = "aws04_ssh_sg"
        Description = "SSH security group"
    }
}