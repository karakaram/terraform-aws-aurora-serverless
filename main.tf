provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {}
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config  = "${var.vpc_state_config}"
}

resource "aws_security_group" "default" {
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
  name        = "${format("%s-sg", var.name)}"
  description = "${format("Security Group for %s", var.name)}"

  ingress {
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
    cidr_blocks = ["${data.terraform_remote_state.vpc.private_subnets_cidr_blocks}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_subnet_group" "default" {
  name        = "${var.name}"
  description = "${var.name}"
  subnet_ids  = ["${data.terraform_remote_state.vpc.private_subnets}"]

  tags {
    Name        = "${var.name}"
    Environment = "${var.environment}"
  }
}

resource "aws_rds_cluster" "default" {
  cluster_identifier      = "${var.name}"
  vpc_security_group_ids  = ["${aws_security_group.default.id}"]
  db_subnet_group_name    = "${aws_db_subnet_group.default.name}"
  engine_mode             = "serverless"
  master_username         = "${var.username}"
  master_password         = "${var.password}"
  backup_retention_period = 7
  skip_final_snapshot     = false

  scaling_configuration {
    auto_pause               = true
    max_capacity             = 2
    min_capacity             = 2
    seconds_until_auto_pause = 300
  }

  lifecycle {
    ignore_changes = [
      "engine_version",
    ]
  }
}
