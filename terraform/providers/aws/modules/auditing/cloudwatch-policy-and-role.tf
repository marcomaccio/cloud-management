# --------------------------------------------------------------------------------------
#              IAM Cloudtrail to CloudWatch Policy Document Definition
# --------------------------------------------------------------------------------------
data "aws_iam_policy_document" "cm_auditing_pd_ct_to_cw" {

  "statement" {
    sid       = "AWSCloudTrailCreateLogStream"
    effect    = "Allow"
    actions   = [
      "logs:CreateLogStream"
    ]
    resources = [
      # More fine-grained
      #"arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:${aws_cloudwatch_log_group.cm_auditing_cloudwatch_log_group.name}:log-stream:${var.aws_account_id}_CloudTrail_${var.aws_region}*"

      "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:${aws_cloudwatch_log_group.cm_auditing_cloudwatch_log_group.name}:log-stream:*"
    ]
  }

  "statement" {
    sid       ="AWSCloudTrailPutLogEvents20141101"
    effect    = "Allow"
    actions   = [
      "logs:PutLogEvents"
    ]
    resources = [
      # More fine-grained
      #"arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:${aws_cloudwatch_log_group.cm_auditing_cloudwatch_log_group.name}:log-stream:${var.aws_account_id}_CloudTrail_${var.aws_region}*"

      "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:${aws_cloudwatch_log_group.cm_auditing_cloudwatch_log_group.name}:log-stream:*"
    ]
  }
}

# --------------------------------------------------------------------------------------
#              IAM Cloudtrail To CloudWatch Policy Definition
# --------------------------------------------------------------------------------------
resource "aws_iam_policy" "cm_auditing_iam_policy_cloudtrail" {
  name        = "cloudtrail-to-cloudwatch-${var.aws_cloudtrail_name}"
  description = "Deliver logs from CloudTrail to CloudWatch."
  policy      = "${data.aws_iam_policy_document.cm_auditing_pd_ct_to_cw.json}"
}

# --------------------------------------------------------------------------------------
#              IAM CloudWatch AssumeRole Policy Document Definition
# --------------------------------------------------------------------------------------
data "aws_iam_policy_document" "cm_auditing_pd_cloudwatch_assume_role" {
  "statement" {
    sid     = ""
    effect  = "Allow"
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type = "Service"
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

# --------------------------------------------------------------------------------------
#              IAM Role Definition
# --------------------------------------------------------------------------------------
resource "aws_iam_role" "cm_auditing_iam_role_cloudtrail" {
  name = "CloudTrailToCloudWatchLogsRole"
  assume_role_policy = "${data.aws_iam_policy_document.cm_auditing_pd_cloudwatch_assume_role.json}"
}

# --------------------------------------------------------------------------------------
#              IAM Role-Policy Attachment Definition
# --------------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "cm_auditing_iam_role_policy_attachement" {
  role        = "${aws_iam_role.cm_auditing_iam_role_cloudtrail.name}"
  policy_arn  = "${aws_iam_policy.cm_auditing_iam_policy_cloudtrail.arn}"
}