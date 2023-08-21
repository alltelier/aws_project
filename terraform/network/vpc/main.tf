resource "aws_vpc" "project04_vpc" {
	cidr_block = var.vpc_cidr
	enable_dns_hostnames 	= true
	enable_dns_support 		= true
	instance_tenancy 		= "default"

	tags = {
		Name = "project04-vpc"
	}
}

#0620화
#-------------------서브넷 만들기---------------------------
#퍼블릭 서브넷2a
resource "aws_subnet" "project04_public_subnet2a" {
	vpc_id = aws_vpc.project04_vpc.id 
	cidr_block = var.public_subnet[0]
	availability_zone = var.azs[0]

	tags = {
		Name = "project04-public-subnet2a"
	}
}


#퍼블릭 서브넷2c
resource "aws_subnet" "project04_public_subnet2c" {
	vpc_id = aws_vpc.project04_vpc.id 
	cidr_block = var.public_subnet[1]
	availability_zone = var.azs[1]

	tags = {
		Name = "project04-public-subnet2c"
	}
}

#프라이빗 서브넷2a
resource "aws_subnet" "project04_private_subnet2a" {
	vpc_id = aws_vpc.project04_vpc.id 
	cidr_block = var.private_subnet[0]
	availability_zone = var.azs[0]

	tags = {
		Name = "project04-private-subnet2a"
	}
}

#프라이빗 서브넷2c
resource "aws_subnet" "project04_private_subnet2c" {
	vpc_id = aws_vpc.project04_vpc.id 
	cidr_block = var.private_subnet[1]
	availability_zone = var.azs[1]

	tags = {
		Name = "project04-private-subnet2c"
	}
}


#0621수
#-------------IGW Internet Gateway-----------------
#사설 IP를 공인 IP로 바꿔서 인터넷 세상에 연결해줌. 
resource "aws_internet_gateway" "project04_igw" {
	vpc_id = aws_vpc.project04_vpc.id

	tags = {
		Name = "project04-igw"
	}
}

#-------------EIP for NAT Gateway-----------------
resource "aws_eip" "project04_eip" {
	vpc = true
	depends_on = [ "aws_internet_gateway.project04_igw" ]
	lifecycle {
		create_before_destroy = true
	}
	tags = {
		Name = "project04_eip"
	}
}

#-------------NAT Gateway----------------
# 프라이빗 서브넷에 위치한 애들을 퍼블릭으로 나갈 수 있게 해줌 
resource "aws_nat_gateway" "project04_nat" {
	allocation_id = aws_eip.project04_eip.id
	# NAT을 생성할 서브넷 위치
	subnet_id = aws_subnet.project04_public_subnet2a.id
	depends_on = ["aws_internet_gateway.project04_igw"]

		tags = {
		Name = "project04-nat"
	}
}


#-------------Public Route Table----------------
# AWS 에서 VPC 를 생성하면 자동으로 Route table 이 생긴다.
# aws_default_route_table 은 route table 을 만들지 않고 VPC 가 만든
# 기본 route table 을 가져와서 terraform 이 관리할 수 있게 함. 
# local 및 IGW (인터넷게이트웨이) 와 연결됨 


resource "aws_default_route_table" "project04_public_rt" {
	default_route_table_id = aws_vpc.project04_vpc.default_route_table_id
	
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.project04_igw.id
		}
	tags = {
		Name = "project04_public_route_table"
	}
}


#디폴트 라우터를 퍼블릭 서브넷에 연결 
resource "aws_route_table_association" "project04_public_rta_2a" {
	subnet_id = aws_subnet.project04_public_subnet2a.id
	route_table_id = aws_default_route_table.project04_public_rt.id
}

resource "aws_route_table_association" "project04_public_rta_2c" {
	subnet_id = aws_subnet.project04_public_subnet2c.id
	route_table_id = aws_default_route_table.project04_public_rt.id
}



#-------------Private Route Table----------------
# 프라이빗 라우트 생성 
resource "aws_route_table" "project04_private_rt1" {
	vpc_id = aws_vpc.project04_vpc.id
	tags = {
		Name = "project04_private_route_table01"
	}
}

resource "aws_route_table" "project04_private_rt2" {
	vpc_id = aws_vpc.project04_vpc.id
	tags = {
		Name = "project04_private_route_table02"
	}
}

# 프라이빗 라우터를 프라이빗 서브넷에 연결 
resource "aws_route_table_association" "project04_private_rta_2a" {
	subnet_id = aws_subnet.project04_private_subnet2a.id
	route_table_id = aws_route_table.project04_private_rt1.id
}

resource "aws_route_table_association" "project04_private_rta_2c" {
	subnet_id = aws_subnet.project04_private_subnet2c.id
	route_table_id = aws_route_table.project04_private_rt2.id
}

#퍼블릭으로 나갈 수 있게 NAT gateway 를 붙여줘야 함. 
resource "aws_route" "project04_private_rt_table1" {
	route_table_id = aws_route_table.project04_private_rt1.id
	destination_cidr_block = "0.0.0.0/0"
	nat_gateway_id = aws_nat_gateway.project04_nat.id 
}

resource "aws_route" "project04_private_rt_table2" {
	route_table_id = aws_route_table.project04_private_rt2.id
	destination_cidr_block = "0.0.0.0/0"
	nat_gateway_id = aws_nat_gateway.project04_nat.id 
}
