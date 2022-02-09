aws_region        = "ap-southeast-1"
aws_key_pair_name = "tf-service-key"

availability_zones = ["ap-southeast-1a", "ap-southeast-1b"]
public_subnets     = ["10.10.100.0/24", "10.10.101.0/24"]
private_subnets    = ["10.10.0.0/24", "10.10.1.0/24"]

app_name        = "node-js-app"
app_environment = "production"