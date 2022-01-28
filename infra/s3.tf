resource "aws_s3_bucket" "terraform-state" {
  bucket = "terraform-state-m1a6799"
  acl    = "private"

  tags = {
    Name = "Terraform state"
  }
}

