variable "profile" {
  default     = ""
  description = "Profile used in the AWS Credentials file"
}

variable "aws_account_id" {
  default     = ""
  description = "AWS Account Id used to reference the aws resources"
}

variable "project_name"           {
  default     = "MM-CloudManagement-Auditing"
  description = "Name of the project "
}

variable "contact_email_list"     {
  default     = ""
  description = "Comma separated list of emails as reference for these objects"
}

variable "aws_region"  {
  default     = "us-east-1"
  description = "Region in cui create the S# bucket where all AWS API Calls are memorized"
}

variable "aws_s3_bucket_name_x_cloudtrail"                {
  default     = ""
  description = "Name of the cloud trail used to receive all logs "
}

variable "aws_cloudtrail_name"                            {
  default     = ""
  description = "Name of the cloud trail used to receive all logs "
}

variable "aws_cloudwatch_logs_log_group_name"             {
  default     = "CloudTrail/AuditLogs"
  description = "Name of the Cloud Watch Logs log group used by Cloud Trails"
}

variable "aws_cloudwatch_logs_log_stream_name"            {
  default     = "mm-security-logstream"
  description = "Name of the CloudWatch Log log stream that will contain the CloudTrail log"
}

variable "aws_cloudwatch_logs_log_metric_filter_name"     {
  default     = "CM-Auditing-UnUsedRegion"
  description = "Name of the CloudWatch Logs metric filter to parse the logs"
}

# This pattern exclude the following regions from the CloudWatch analysis:
# - us-east-1
# - eu-central-1
variable "aws_cloudwatch_logs_log_metric_filter_pattern"  {
  default     = "{($.awsRegion != \"us-east-1\" && $.awsRegion != \"eu-central-1\")}"
  description = "Pattern to exclude some regions from the cloud watch alarms"
}

variable "aws_cloudwatch_metric_alarm_name"               {
  default     = "CM-Activity-In-UnUsedRegion"
  description = "Name for the metric alarm"
}

variable "aws_cloudwatch_metric_alarm_metric_name"        {
  default     = "UnusedRegionActivity"
  description = "Name for the metric associated to the alarm"
}

variable "aws_cloudwatch_metric_namespace"                {
  default     = "AWS/CloudWatch"
  description = "Namespace for the metric alarm"
}

variable "aws_sns_region" {
  default     = "us-east-1"
  description = "AWS Region in which the SNS topic is created: us-east-1"
}

variable "sns_topic_name" {
  default     = "NotifyMe"
  description = "Name for the SNS Topic that will be used by Cloud Watch to send the notification to"
}

variable "email_auditing" {
  default     = ""
  description = "Email to which notify auditing notification sent by CloudWatch alarms"
}