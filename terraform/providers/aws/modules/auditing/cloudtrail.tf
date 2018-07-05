# --------------------------------------------------------------------------------------
#              CloudTrail Definition
# --------------------------------------------------------------------------------------
resource "aws_cloudtrail" "cm_auditing_cloudtrail" {

  name                          = "${var.aws_cloudtrail_name}"
  s3_bucket_name                = "${aws_s3_bucket.cm_auditing_s3_bucket.id}"

  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true

  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cm_auditing_cloudwatch_log_group.arn}"
  cloud_watch_logs_role_arn     = "${aws_iam_role.cm_auditing_iam_role_cloudtrail.arn}"

  depends_on                    = ["aws_s3_bucket_policy.cm_auditing_s3_bucket_policy"]

  tags {
    "name"        = "auditing"
    "projectName" = "${var.project_name}"
  }

}