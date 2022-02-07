# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "2.70.0"
#     }
#   }

#   backend "s3" {
#     bucket = "terraform-state-bucket-node-js-app-19191a"
#     key    = "state/terraform_state.tfstate"
#     region = "ap-southeast-1"
#   }
# }
