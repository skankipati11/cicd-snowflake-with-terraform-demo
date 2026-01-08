terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.63.0"
    }
  }

  backend "s3" {
    bucket         = "tf-state-store-sk"
    key            = "terraform-staging.tfstate"
    region         = "ap-south-1"
    # Optional DynamoDB for state locking. See https://developer.hashicorp.com/terraform/language/settings/backends/s3 for details.
    dynamodb_table = "terraform-state-lock-table"
    encrypt        = true    
  }
}

provider "snowflake" {  
  username    = "skankipati"
  account     = "XODJOPC-JTC04659"
  role        = "ACCOUNTADMIN"
  private_key = var.snowflake_private_key
}

module "snowflake_resources" {
  source              = "../modules/snowflake_resources"
  time_travel_in_days = 1
  database            = var.database
  env_name            = var.env_name
}