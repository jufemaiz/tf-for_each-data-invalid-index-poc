#--------------------------------------------------------------
# S3 Notification
#--------------------------------------------------------------

variable "bucket_name" {
  type = string
}

#--------------------------------------------------------------
# S3 Notification
#--------------------------------------------------------------

variable "s3_sns_notification_details" {
  type = map(
    object({
      prefix = string,
      suffix = string
    })
  )
  default = {}
}
