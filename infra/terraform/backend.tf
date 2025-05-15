terraform {
  backend "s3" {
    region       = "us-east-1"
    bucket       = "terraform-deamaya"
    key          = "cors/cors.tfstate"
    use_lockfile = true
    encrypt      = true
  }
}
