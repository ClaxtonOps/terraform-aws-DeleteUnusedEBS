resource "random_uuid" "random" {
}
resource "aws_iam_role" "lambda_role_ebs" {
  name = "UnusedEBSvolumes_Role-${random_uuid.random.result}"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}


resource "aws_iam_policy" "iam_policy_for_lambda_ebs" {
  name        = "UnusedEBSvolumes_Policy-${random_uuid.random.result}"
  path        = "/"
  description = "AWS IAM Policy for managing AWS Lambda role"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ec2:DescribeVolumes"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DeleteVolume"
        ],
        "Resource" : "*",
        "Condition" : {
          "StringNotEquals" : {
            "ec2:ResourceTag/Environment" : "${local.lambda.rules.environments_string}"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "sns:Publish"
        ],
        "Resource" : "${aws_sns_topic.lambda_error_topic.arn}"
      }
    ]
  })
}





resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_role_ebs.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda_ebs.arn
}