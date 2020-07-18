resource "aws_s3_bucket" "cloudwatch_logs" {
  bucket = "yaizuuuu-cloudwatch-logs-pragmatic-terraform"

  lifecycle_rule {
    enabled = true

    expiration {
      days = 180
    }
  }
}

data "aws_iam_policy_document" "kinesis_data_firehose" {
  statement {
    effect = "Allow"

    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.cloudwatch_logs.id}",
      "arn:aws:s3:::${aws_s3_bucket.cloudwatch_logs.id}/*",
    ]
  }
}

module "kinesis_data_firehose_role" {
  source = "./iam_role"

  identifier = "firehose.amazonaws.com"
  name       = "kinesis-data-firehose"
  policy     = data.aws_iam_policy_document.kinesis_data_firehose.json
}

resource "aws_kinesis_firehose_delivery_stream" "example" {
  destination = "s3"
  name        = "example"

  s3_configuration {
    bucket_arn = aws_s3_bucket.cloudwatch_logs.arn
    role_arn   = module.kinesis_data_firehose_role.iam_role_arn
    prefix     = "ecs-scheduled-tasks/example/"
  }
}

data "aws_iam_policy_document" "cloudwatch_logs" {
  statement {
    effect    = "Allow"
    actions   = ["firehose:*"]
    resources = ["arn:aws:firehose:us-east-1:*:*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = ["arn:aws:iam::*:role/cloudwatch-logs"]
  }
}

module "cloudwatch_logs_role" {
  source = "./iam_role"

  identifier = "logs.us-east-1.amazonaws.com"
  name       = "cloudwatch-logs"
  policy     = data.aws_iam_policy_document.cloudwatch_logs.json
}

resource "aws_cloudwatch_log_subscription_filter" "example" {
  destination_arn = aws_kinesis_firehose_delivery_stream.example.arn
  filter_pattern  = "[]"
  log_group_name  = aws_cloudwatch_log_group.for_ecs_scheduled_task.name
  name            = "example"
  role_arn        = module.cloudwatch_logs_role.iam_role_arn
}