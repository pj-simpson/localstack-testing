terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# resource "aws_db_instance" "rds_postgres" {
#   allocated_storage    = 1
#   db_name              = "rds_postgres_test"
#   engine               = "postgres"
#   instance_class       = "db.t3.small"
#   username             = "test"
#   password             = "test"
#   identifier           = "rdspostgrestest"
#   skip_final_snapshot  = true
#   iam_database_authentication_enabled = false
# }

resource "aws_rds_cluster" "rds_postgres_cluster" {
  cluster_identifier      = "rdspostgresclustertest"
  engine                  = "aurora-postgresql"
  database_name           = "rds_postgres_cluster_test"
  master_username         = "test"
  master_password         = "test"
  skip_final_snapshot  = true
}

resource "aws_rds_cluster_instance" "rds_postgres_cluster_instances" {
  count              = 2
  identifier         = "rdspostgresclustertest-${count.index}"
  cluster_identifier = "${aws_rds_cluster.rds_postgres_cluster.cluster_identifier}"
  instance_class     = "db.t3.small"
  engine             = "aurora-postgresql"
}

resource "aws_rds_cluster_endpoint" "rds_postgres_cluster_endpoints" {
  cluster_identifier          = "${aws_rds_cluster.rds_postgres_cluster.cluster_identifier}"
  cluster_endpoint_identifier = "rdspostgresclusterendpoints"
  custom_endpoint_type        = "ANY"
}