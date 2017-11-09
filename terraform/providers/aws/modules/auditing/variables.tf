variable "profile" {
  default     = ""
  description = "Profile used in the AWS Credentials file"
}

variable "aws_account_id" {
  default     = ""
  description = "AWS Account Id used to reference the aws resources"
}

variable "project_name"           {
  default     = ""
  description = "Name of the project that "
}

variable "contact_email_list"     {
  default     = ""
  description = "Comma separated list of emails as reference for these objects"
}

variable "aws_region"  {
  default     = "us-east-1"
  description = "Region in cui create the S# bucket where all AWS API Calls are memorized"
}

variable "aws_cloudtrail_name"    {
  default     = ""
  description = "Name of the cloud trail used to receive all logs "
}

variable "aws_cloudwatch_logs_group_name" {
  default     = "CloudTrail/SecurityLogs"
  description = "Name of the Cloud Watch Logs log group used by Cloud Trails"
}

variable "aws_cloudwatch_logs_log_stream_name" {
  default     = "mm-security-logstream"
  description = ""
}

variable "email_auditing" {
  default     = ""
  description = "email to notify when auditing notification has to be sent"
}