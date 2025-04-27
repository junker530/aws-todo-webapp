terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                   = "ap-northeast-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "dev"
}

# ------------------------------------
# Data
# ------------------------------------
data "aws_region" "current" {} #

# ------------------------------------
# Variables
# ------------------------------------
variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "mysql_database" {
  type = string
}

variable "mysql_username" {
  type = string
}

variable "mysql_password" {
  type = string
}

locals {
  vpc_cidr_block             = "10.0.0.0/16"
  public_subnet_cidr_blocks  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones         = ["ap-northeast-1a", "ap-northeast-1c"]
}