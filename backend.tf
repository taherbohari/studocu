#terraform {
#  backend "s3" {
#    bucket = "studocu-assignment"
#    key    = "state"
#    region = "eu-west-3"
#  }
#}

terraform {
  backend "s3" {}
}
