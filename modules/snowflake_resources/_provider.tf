terraform {
  required_providers {
    snowflake = {
      source  = "snowflakedb/snowflake"
      version = "~> 1.40"  # adjust to latest stable    
    }
  }
}