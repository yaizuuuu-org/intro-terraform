variable "name" {}
variable "policy" {}
variable "identifier" {}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = [var.identifier]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "default" {
  name = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "default" {
  name = var.name
  policy = var.policy
}

resource "aws_iam_role_policy_attachment" "default" {
  policy_arn = aws_iam_policy.default.arn
  role = aws_iam_role.default.name
}

output "iam_role_arn" {
  value = aws_iam_role.default.arn
}
