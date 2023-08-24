terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_dynamodb_table" "python_todo_table" {
 name = "python_todo_table"
 read_capacity= "30"
 write_capacity= "30"
 attribute {
  name = "id"
  type = "S"
 }
 hash_key = "id"
}


resource "aws_lambda_function" "list_create_todo" {
  function_name = "list_create_todo"

  s3_bucket = "python-todo"
  s3_key    = "py2d.zip"

  handler = "list_or_create.list_or_create_dispatcher"
  runtime = "python3.10"

  role = "${aws_iam_role.lambda_exec.arn}"
}

resource "aws_lambda_function" "get_update_delete_todo" {
  function_name = "get_update_delete_todo"

  s3_bucket = "python-todo"
  s3_key    = "py2d.zip"

  handler = "get_update_delete.get_or_update_or_delete_dispatcher"
  runtime = "python3.10"

  role = "${aws_iam_role.lambda_exec.arn}"
}


resource "aws_iam_role" "lambda_exec" {
  name = "serverless_example_lambda"

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

resource "aws_lambda_permission" "list_create_todo_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.list_create_todo.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.python_todo_rest_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "get_update_delete_todo_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.get_update_delete_todo.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.python_todo_rest_api.execution_arn}/*/*"
}