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
  user              = "TERRAFORM_SVC"
  role              = "SYSADMIN"
  authenticator     = "SNOWFLAKE_JWT"
  private_key       = var.snowflake_private_key
}

resource "snowflake_database" "tf_db" {
  name         = "TF_DEMO_DB"
  is_transient = false
}

resource "snowflake_warehouse" "tf_warehouse" {
  name                      = "TF_DEMO_WH"
  warehouse_type            = "STANDARD"
  warehouse_size            = "SMALL"
  max_cluster_count         = 1
  min_cluster_count         = 1
  auto_suspend              = 60
  auto_resume               = true
  enable_query_acceleration = false
  initially_suspended       = true
}

# Create a new schema in the DB
resource "snowflake_schema" "tf_db_tf_schema" {
  name                = "TF_DEMO_SC"
  database            = snowflake_database.tf_db.name
  with_managed_access = false
}

