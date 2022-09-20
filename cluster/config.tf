provider "aws" {
  region = var.region
}

resource "random_integer" "suffix" {
  min = 100
  max = 999
}