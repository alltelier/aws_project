variable "vpc_cidr" {
    default = "10.4.0.0/16" 
}

variable "public_subnet" {
    type    = list
    default = ["10.4.101.0/24", "10.4.103.0/24"]
}
                # => public_subnet[0], public_subnet[1]


variable "private_subnet" {
    type    = list
    default = ["10.4.1.0/24", "10.4.3.0/24"]
}
                # => private_subnet[0], private_subnet[1]

variable "azs" {
    type    = list 
    default = ["ap-northeast-2a", "ap-northeast-2c"]

}