terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  // Lê a região da variável declarada em variable.tf.
  region = var.region
}