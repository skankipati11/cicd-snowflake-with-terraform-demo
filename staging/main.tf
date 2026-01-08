terraform {
  required_providers {
    snowflake = {
      source = "snowflakedb/snowflake"
    }
  }

  backend "s3" {
    bucket         = "tf-state-store-sk"
    key            = "terraform-staging.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock-table"
    encrypt        = true
  }
}

provider "snowflake" {
  organization_name = "xodjopc"
  account_name      = "jtc04659"
  user              = "SKANKIPATI"
  role              = "ACCOUNTADMIN"
  authenticator     = "SNOWFLAKE_JWT"
  private_key       = var.snowflake_private_key
}

module "snowflake_resources" {
  source              = "../modules/snowflake_resources"
  time_travel_in_days = 1
  database            = var.database
  env_name            = var.env_name
}