##################################################
############## Bics Beta Regression ##############
##################################################

resource "aws_iam_role" "bics_betaregression_role" {
  name = "bics_betaregression_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "bics_betaregression_role_attachment" {
  role       = "${aws_iam_role.bics_betaregression_role.name}"
  policy_arn = "${aws_iam_policy.bics_role_policy_for_lambda.arn}"
}

data "aws_sns_topic" "bics_ec2_notification_topic" {
  name = "${var.bics_ec2_notification_topic}"
}

resource "aws_sns_topic_subscription" "bics_ec2_notification_subscription" {
  topic_arn = "${data.aws_sns_topic.bics_ec2_notification_topic.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.bics_betaregression.arn}"
}

resource "aws_lambda_function" "bics_betaregression" {
  function_name    = "bics_betaregression"
  filename         = "files/BICS_BetaRegression.zip"
  role             = "${aws_iam_role.bics_betaregression_role.arn}"
  handler          = "BICS_BetaRegression.lambda_handler"
  runtime          = "python3.6"
  timeout          = "900"
  memory_size      = "512"
}

resource "aws_lambda_permission" "allow_from_bics_ec2_notification_topic" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.bics_betaregression.arn}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${data.aws_sns_topic.bics_ec2_notification_topic.arn}"
}

##################################################
############## Build EC2 Start Python ############
##################################################

data "aws_s3_bucket" "bucket" {
  bucket = "${var.prerequisite_s3_bucket}"
}

resource "aws_s3_bucket_notification" "s3_bucket_notification" {
  bucket = "${data.aws_s3_bucket.bucket.id}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.bics_ec2_start_python.arn}"
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "bics/Input/"
  }

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.bics_ec2_stop_python.arn}"
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "bics/Outputs/"
  }
}

resource "aws_iam_role" "bics_ec2_start_python_role" {
  name = "bics_ec2_start_python_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "bics_ec2_start_python_role_attachment" {
  role       = "${aws_iam_role.bics_ec2_start_python_role.name}"
  policy_arn = "${aws_iam_policy.bics_role_policy_for_lambda.arn}"
}

resource "aws_lambda_permission" "allow_from_input_bucket" {
  statement_id  = "AllowExecutionFromS3BucketInputBucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.bics_ec2_start_python.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${data.aws_s3_bucket.bucket.arn}"
}

resource "aws_lambda_function" "bics_ec2_start_python" {
  function_name    = "bics_ec2_start_python"
  filename         = "files/bics_ec2_start_python.zip"
  role             = "${aws_iam_role.bics_ec2_start_python_role.arn}"
  handler          = "bics_ec2_start_python.lambda_handler"
  runtime          = "python3.6"
  timeout          = "900"
  memory_size      = "512"
}

##################################################
############## Build EC2 Stop Python ############
##################################################

resource "aws_iam_role" "bics_ec2_stop_python_role" {
  name = "bics_ec2_stop_python_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "bics_ec2_stop_python_role_attachment" {
  role       = "${aws_iam_role.bics_ec2_stop_python_role.name}"
  policy_arn = "${aws_iam_policy.bics_role_policy_for_lambda.arn}"
}

resource "aws_lambda_function" "bics_ec2_stop_python" {
  function_name    = "bics_ec2_stop_python"
  filename         = "files/bics_ec2_stop_python.zip"
  role             = "${aws_iam_role.bics_ec2_stop_python_role.arn}"
  handler          = "bics_ec2_stop_python.lambda_handler"
  runtime          = "python3.6"
  timeout          = "900"
  memory_size      = "512"
}

data "aws_sns_topic" "bics_error_notification_topic" {
  name = "${var.bics_error_notification_topic}"
}

resource "aws_sns_topic_subscription" "bics_error_notification_subscription" {
  topic_arn = "${data.aws_sns_topic.bics_error_notification_topic.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.bics_ec2_stop_python.arn}"
}

resource "aws_lambda_permission" "allow_from_output_bucket" {
  statement_id  = "AllowExecutionFromS3OutputBucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.bics_ec2_stop_python.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${data.aws_s3_bucket.bucket.arn}"
}

resource "aws_lambda_permission" "allow_from_sns_error_topic" {
  statement_id  = "AllowExecutionFromSNSerrorTopic"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.bics_ec2_stop_python.arn}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${data.aws_sns_topic.bics_error_notification_topic.arn}"
}

##################################################
################ Common Resources ################
##################################################

resource "aws_iam_policy" "bics_role_policy_for_lambda" {
  name = "bics_role_policy_for_lambda"
  description = "A common role for all the lambda function of bics."

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudformation:DescribeChangeSet",
        "cloudformation:DescribeStackResources",
        "cloudformation:DescribeStacks",
        "cloudformation:GetTemplate",
        "cloudformation:ListStackResources",
        "cloudwatch:*",
        "cognito-identity:ListIdentityPools",
        "cognito-sync:GetCognitoEvents",
        "cognito-sync:SetCognitoEvents",
        "dynamodb:*",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcs",
        "events:*",
        "iam:GetPolicy",
        "iam:GetPolicyVersion",
        "iam:GetRole",
        "iam:GetRolePolicy",
        "iam:ListAttachedRolePolicies",
        "iam:ListRolePolicies",
        "iam:ListRoles",
        "iam:PassRole",
        "iot:AttachPrincipalPolicy",
        "iot:AttachThingPrincipal",
        "iot:CreateKeysAndCertificate",
        "iot:CreatePolicy",
        "iot:CreateThing",
        "iot:CreateTopicRule",
        "iot:DescribeEndpoint",
        "iot:GetTopicRule",
        "iot:ListPolicies",
        "iot:ListThings",
        "iot:ListTopicRules",
        "iot:ReplaceTopicRule",
        "kinesis:DescribeStream",
        "kinesis:ListStreams",
        "kinesis:PutRecord",
        "kms:ListAliases",
        "lambda:*",
        "logs:*",
        "s3:*",
        "sns:ListSubscriptions",
        "sns:ListSubscriptionsByTopic",
        "sns:ListTopics",
        "sns:Publish",
        "sns:Subscribe",
        "sns:Unsubscribe",
        "sqs:ListQueues",
        "sqs:SendMessage",
        "tag:GetResources",
        "xray:PutTelemetryRecords",
        "xray:PutTraceSegments"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    },
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": "ssm:*",
      "Resource": "*"
    }
  ]
}
EOF
}
