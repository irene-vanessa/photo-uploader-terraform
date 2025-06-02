provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "photo_bucket" {
  bucket = "photo-uploader-demo-${random_id.rand.hex}"
}

resource "random_id" "rand" {
  byte_length = 4
}

resource "aws_dynamodb_table" "photo_metadata" {
  name           = "PhotoMetadata"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "photo_name"

  attribute {
    name = "photo_name"
    type = "S"
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "photoUploaderLambdaRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Effect = "Allow",
      Sid    = ""
    }]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambdaPolicy"
  role = aws_iam_role.lambda_exec.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:PutItem"
        ],
        Resource = aws_dynamodb_table.photo_metadata.arn
      },
      {
        Effect = "Allow",
        Action = [
          "logs:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_lambda_function" "photo_handler" {
  function_name = "PhotoMetadataHandler"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  filename      = "${path.module}/lambda.zip"
  role          = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.photo_metadata.name
    }
  }
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.photo_handler.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.photo_bucket.arn
}

resource "aws_s3_bucket_notification" "bucket_notify" {
  bucket = aws_s3_bucket.photo_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.photo_handler.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
