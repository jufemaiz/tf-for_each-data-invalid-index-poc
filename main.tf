terraform {
  required_version = "~> 0.13"

  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.7"
    }
  }
}

# -----------------------------------------
# S3 Bucket Notifications
# -----------------------------------------

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  acl    = "private"
}

# -----------------------------------------
# S3 Bucket Notifications
# -----------------------------------------

resource "aws_s3_bucket_notification" "this" {
  bucket = aws_s3_bucket.this.id

  dynamic "topic" {
    for_each = var.s3_sns_notification_details
    content {
      topic_arn     = aws_sns_topic.this[topic.key].arn
      events        = ["s3:ObjectCreated:*"]
      filter_prefix = topic.value.prefix
      filter_suffix = topic.value.suffix
    }
  }
}

# -----------------------------------------
# SNS
# -----------------------------------------

resource "aws_sns_topic" "this" {
  for_each = var.s3_sns_notification_details

  name = each.key
}

resource "aws_sns_topic_policy" "sns_publish" {
  for_each = var.s3_sns_notification_details

  arn = aws_sns_topic.this[each.key].arn

  policy = data.aws_iam_policy_document.sns_publish[each.key].json
}

data "aws_iam_policy_document" "sns_publish" {
  for_each = var.s3_sns_notification_details

  statement {
    sid = "S3PublishToTopic"

    actions = ["SNS:Publish"]

    resources = [aws_sns_topic.this[each.key].arn]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}
