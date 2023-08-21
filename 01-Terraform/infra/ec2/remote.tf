#VPC 정보를 가져오는 곳
data "terraform_remote_state" "project04_vpc" {
    backend = "s3"
    config = {
                #vpc는 project04 사용. 
        bucket  = "project04-terraform-state"
        key     = "infra/network/vpc/terraform.tfstate"
        region  = "ap-northeast-2"
    }
}