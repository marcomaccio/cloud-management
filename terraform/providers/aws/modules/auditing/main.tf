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



# --------------------------------------------------------------------------------------
#              S3 Bucket Definition
# --------------------------------------------------------------------------------------
resource "aws_s3_bucket" "auditing_s3_bucket" {
  bucket        = "${var.aws_cloudtrail_name}"
  force_destroy = true

  // policy =  "${aws_s3_bucket_policy.auditing_s3_bucket_policy.id}" //"${file("policy_s3.json")}"

}

# --------------------------------------------------------------------------------------
#               S3 Bucket Policy Definition
# --------------------------------------------------------------------------------------
resource "aws_s3_bucket_policy" "auditing_s3_bucket_policy" {
  bucket = "${aws_s3_bucket.auditing_s3_bucket.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailAclCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "${aws_s3_bucket.auditing_s3_bucket.arn}"
    },
    {
      "Sid": "AWSCloudTrailWrite",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket.auditing_s3_bucket.arn}/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    }
  ]
}
POLICY
}

# --------------------------------------------------------------------------------------
#              CloudWatch Logs Log Group Definition
# --------------------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "auditing_cloudwatch_log_group" {
  name = "CloudTrail/SecurityLogs"

  tags {
    "name"        = "auditing"
    "projectName" = "${var.project_name}"
  }
}

# --------------------------------------------------------------------------------------
#              CloudWatch Logs Log Stream Definition
# --------------------------------------------------------------------------------------
resource "aws_cloudwatch_log_stream" "auditing_cloudwatch_log_stream" {
  name           = "${var.aws_cloudwatch_logs_log_stream_name}"
  log_group_name = "${aws_cloudwatch_log_group.auditing_cloudwatch_log_group.name}"
}

resource "aws_iam_role" "auditing_iam_role_cloudtrail" {
  name = "cloudtrail-to-cloudwatch-${var.aws_cloudtrail_name}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# --------------------------------------------------------------------------------------
#              IAM Cloudtrail Policy Definition
# --------------------------------------------------------------------------------------
resource "aws_iam_policy" "auditing_iam_policy_cloudtrail" {
  name = "cloudtrail-to-cloudwatch-${var.aws_cloudtrail_name}"
  description = "Deliver logs from CloudTrail to CloudWatch."
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailCreateLogStream",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream"
      ],
      "Resource": [
        "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:${aws_cloudwatch_log_group.auditing_cloudwatch_log_group.name}:log-stream:${var.aws_account_id}_CloudTrail_${var.aws_region}*"
      ]
    },
    {
      "Sid": "AWSCloudTrailPutLogEvents",
      "Effect": "Allow",
      "Action": [
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:${aws_cloudwatch_log_group.auditing_cloudwatch_log_group.name}:log-stream:${var.aws_account_id}_CloudTrail_${var.aws_region}*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "auditing_iam_role_policy_attachement" {
  role        = "${aws_iam_role.auditing_iam_role_cloudtrail.name}"
  policy_arn  = "${aws_iam_policy.auditing_iam_policy_cloudtrail.arn}"
}

# --------------------------------------------------------------------------------------
#              CloudTrail Definition
# --------------------------------------------------------------------------------------
resource "aws_cloudtrail" "auditing_cloudtrail" {

  name                          = "${var.aws_cloudtrail_name}"
  s3_bucket_name                = "${aws_s3_bucket.auditing_s3_bucket.id}"
  s3_key_prefix                 = "prefix"
  include_global_service_events = true
  is_multi_region_trail         = true

  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.auditing_cloudwatch_log_group.arn}"
  cloud_watch_logs_role_arn     = "${aws_iam_role.auditing_iam_role_cloudtrail.arn}"

  tags {
    "name"        = "auditing"
    "projectName" = "${var.project_name}"
  }

}

