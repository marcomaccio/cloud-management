# --------------------------------------------------------------------------------------
#               S3 Bucket Policy Document Definition
# --------------------------------------------------------------------------------------
data "aws_iam_policy_document" "cm_auditing_s3_policy_document" {

  statement {
    sid = "AWSCloudTrailAclCheck"
    effect = "Allow"
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type = "Service"
    }
    actions = [
      "s3:GetBucketAcl"
    ]
    resources = [
      "${aws_s3_bucket.cm_auditing_s3_bucket.arn}"
    ]
  }

  statement {
    sid = "AWSCloudTrailWrite"
    effect = "Allow"
    principals {
      identifiers = [
        "cloudtrail.amazonaws.com"]
      type = "Service"
    }
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.cm_auditing_s3_bucket.arn}/*",
    ]
    condition {
      test = "StringEquals"
      values = [
        "bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }
  }

}

# --------------------------------------------------------------------------------------
#               S3 Bucket Policy Definition
# --------------------------------------------------------------------------------------
resource "aws_s3_bucket_policy" "cm_auditing_s3_bucket_policy" {
  bucket = "${aws_s3_bucket.cm_auditing_s3_bucket.id}"

  policy = "${data.aws_iam_policy_document.cm_auditing_s3_policy_document.json}"
}

# --------------------------------------------------------------------------------------
#              S3 Bucket Definition
# --------------------------------------------------------------------------------------
resource "aws_s3_bucket" "cm_auditing_s3_bucket" {
  bucket        = "${var.aws_s3_bucket_name_x_cloudtrail}"
  force_destroy = false

  lifecycle_rule {
    id = "log"
    enabled = true

    transition {
      days = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }
  }

}