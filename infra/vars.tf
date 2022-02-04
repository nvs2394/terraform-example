variable "AWS_REGION" {
  default = "eu-west-1"
}

variable "SERVICE_NAME" {
  description = "Name to use for resources"
  default = "ms-example"
}

variable "PATH_TO_PRIVATE_KEY" {
  desdescription = "Private key name use for ssh"
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  desdescription = "Public key name use for ssh"
  default = "mykey.pub"
}

variable "ECS_INSTANCE_TYPE" {
  desdescription = "EC2 instance type use for deploy service"
  default = "t2.micro"
}

variable "ECS_AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-1924770e"
    us-west-2 = "ami-56ed4936"
    eu-west-1 = "ami-c8337dbb"
  }
}

# Full List: http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-13be557e"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-844e0bf7"
  }
}


variable "TAGS" {
  description = "tags"
  type=map(string)

  default = {
    "managed_by"="terraform"
  }
}
