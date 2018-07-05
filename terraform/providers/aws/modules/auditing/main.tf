terraform {
  required_version = "> 0.9.0"

  backend "s3" {
    region  = "us-east-1"
    bucket  = "mm-global-sec"
    key     = "global-security/terraform.tfstate"
  }
}

# AWS Provider configuration
provider "aws" {
  region                  = "${var.aws_region}"
  shared_credentials_file = "${pathexpand("~/.aws/credentials")}"
  profile                 = "${var.profile}"
}

# provider to manage SNS topics
provider "aws" {
  alias = "sns"
  region = "${var.aws_sns_region}"
}

# --------------------------------------------------------------------------------------
#              CloudWatch Logs Log Stream Definition
# --------------------------------------------------------------------------------------
/*
resource "aws_cloudwatch_log_stream" "auditing_cloudwatch_log_stream" {
  name           = "${var.aws_cloudwatch_logs_log_stream_name}"
  log_group_name = "${aws_cloudwatch_log_group.auditing_cloudwatch_log_group.name}"
}
*/