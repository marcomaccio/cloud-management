# --------------------------------------------------------------------------------------
#              SNS Topic Definition
# --------------------------------------------------------------------------------------
resource "aws_sns_topic" "cm_auditing_sns_topic_audit_notification" {
  name = "${var.sns_topic_name}"

  /**
  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.email_auditing}"
  }
  */
}

/**
resource "aws_sns_topic_subscription" "cm_auditing_sns_topic_sub_email" {
  provider  = "aws.sns"
  topic_arn = "${aws_sns_topic.cm_auditing_sns_topic_audit_notification.arn}"
  protocol  = "email"
  endpoint  = "${var.email_auditing}"
}
*/