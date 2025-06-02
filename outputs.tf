output "bucket_name" {
  value = aws_s3_bucket.photo_bucket.bucket
}

output "lambda_name" {
  value = aws_lambda_function.photo_handler.function_name
}
