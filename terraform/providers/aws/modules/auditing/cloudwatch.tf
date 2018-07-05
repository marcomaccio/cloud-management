# --------------------------------------------------------------------------------------
#              CloudWatch Logs Log Group Definition
# --------------------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "cm_auditing_cloudwatch_log_group" {
  name = "${var.aws_cloudwatch_logs_log_group_name}"

  tags {
    "name"        = "auditing"
    "projectName" = "${var.project_name}"
  }
}

# --------------------------------------------------------------------------------------
#              CloudWatch Logs Log Metric Filter Definition
# --------------------------------------------------------------------------------------
resource "aws_cloudwatch_log_metric_filter" "cm_auditing_cloudwatch_log_metric_filter" {
  name           = "${var.aws_cloudwatch_logs_log_metric_filter_name}" #" ex. CM-Auditing-UnUsedRegion"

  # This pattern exclude the following regions from the CloudWatch analysis:
  # - us-east-1
  # - eu-central-1

  pattern        = "${var.aws_cloudwatch_logs_log_metric_filter_pattern}"   # "{($.awsRegion != \"us-east-1\" && $.awsRegion != \"eu-central-1\")}"

  log_group_name = "${aws_cloudwatch_log_group.cm_auditing_cloudwatch_log_group.name}"

  metric_transformation {
    name      = "UnusedRegions"
    namespace = "LogMetrics"
    value     = "1"
  }
}

# --------------------------------------------------------------------------------------
#              CloudWatch Logs Metric Alarm Definition
# --------------------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "cm_auditing_cloudwatch_metric_alarm_unusedregionactivity" {
  alarm_name          = "${var.aws_cloudwatch_metric_alarm_name}"         # ex. "CM-Alarm-Activity-In-UnUsedRegion"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "${var.aws_cloudwatch_metric_alarm_metric_name}"  # ex. "UnusedRegionActivity"
  namespace           = "${var.aws_cloudwatch_metric_namespace}"          # ex. "AWS/CloudWatch"

  period              = "300"
  statistic           = "Sum"
  threshold           = "50"

  alarm_description   = "This metric monitors the AWS API activity in unused regions"
  alarm_actions       = ["${aws_sns_topic.cm_auditing_sns_topic_audit_notification.arn}"]

  insufficient_data_actions = []

  depends_on          =["aws_sns_topic.cm_auditing_sns_topic_audit_notification"]

}
