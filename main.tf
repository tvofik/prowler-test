provider "aws" {
  region = "us-east-1"
}
# Get Account ID 
data "aws_caller_identity" "current" {}

resource "aws_iam_role" "prowler_role" {
  name = "Prowler-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:AssumeRole"]
        Effect = "Allow"
        Sid    = "AllowIamUserAssumeRole"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/Abayomi"
        }
        # Condition = {
        #   StringLike = {
        #     "aws:PrincipalArn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/Abayomi"
        #   }
        # }
      },
      {
        Action = ["sts:TagSession"]
        Effect = "Allow"
        Sid    = "AllowPassSessionTags"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/Abayomi"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "secuirty-policy-attach" {
  role       = aws_iam_role.prowler_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}
resource "aws_iam_role_policy_attachment" "viewonly-policy-attach" {
  role       = aws_iam_role.prowler_role.name
  policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}


// prowler-additions-policy
resource "aws_iam_role_policy" "prowler-additions-policy" {
  name = "ProwlerAdditionsPolicy"
  role = aws_iam_role.prowler_role.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "access-analyzer:List*",
          "apigateway:Get*",
          "apigatewayv2:Get*",
          "aws-marketplace:ViewSubscriptions",
          "dax:ListTables",
          "ds:ListAuthorizedApplications",
          "ds:DescribeRoles",
          "ec2:GetEbsEncryptionByDefault",
          "ecr:Describe*",
          "lambda:GetAccountSettings",
          "lambda:GetFunctionConfiguration",
          "lambda:GetLayerVersionPolicy",
          "lambda:GetPolicy",
          "opsworks-cm:Describe*",
          "opsworks:Describe*",
          "secretsmanager:ListSecretVersionIds",
          "sns:List*",
          "sqs:ListQueueTags",
          "states:ListActivities",
          "support:Describe*",
          "tag:GetTagKeys"
        ]
        Resource = "*"
        Effect   = "Allow"
        Sid      = "AllowMoreReadForProwler"
      }
    ]
  })
}

/*
if you want porwler to send findings to AWS SECUIRTY HUB
prowler-security-hub
*/
# resource "aws_iam_role_policy" "prowler-security-policy" {
#   name = "ProwlerSecurityHubPolicy"
#   role = aws_iam_role.prowler_role.name
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "securityhub:BatchImportFindings",
#           "securityhub:GetFindings"
#         ]
#         Effect   = "Allow",
#         Resource = "*"
#         Sid      = "AllowSecuirtyHubForProwler"
#       }
#     ]
#   })
# }