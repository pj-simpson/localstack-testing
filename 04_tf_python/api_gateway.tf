resource "aws_api_gateway_rest_api" "python_todo_rest_api" {
  name        = "Todo"
  description = "Terraform Serverless Application Example"
}

# LIST, CREATE

resource "aws_api_gateway_resource" "list_create_todo" {
  rest_api_id = "${aws_api_gateway_rest_api.python_todo_rest_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.python_todo_rest_api.root_resource_id}"
  path_part   = "todos"
}

resource "aws_api_gateway_method" "list_create_todo_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.python_todo_rest_api.id}"
  resource_id   = "${aws_api_gateway_resource.list_create_todo.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "list_create_todo_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.python_todo_rest_api.id}"
  resource_id = "${aws_api_gateway_method.list_create_todo_method.resource_id}"
  http_method = "${aws_api_gateway_method.list_create_todo_method.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.list_create_todo.invoke_arn}"
}


resource "aws_api_gateway_deployment" "list_create_todo_deployment" {
  depends_on = [
    "aws_api_gateway_integration.list_create_todo_integration",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.python_todo_rest_api.id}"
  stage_name  = "test"
}

output "list_create_base_url" {
  value = "${aws_api_gateway_deployment.list_create_todo_deployment.invoke_url}"
}

# GET, UPDATE, DELETE

resource "aws_api_gateway_resource" "get_update_delete_todo" {
  rest_api_id = "${aws_api_gateway_rest_api.python_todo_rest_api.id}"
  parent_id   = "${aws_api_gateway_resource.list_create_todo.id}"
  path_part   = "{id}"
}

resource "aws_api_gateway_method" "get_update_delete_todo_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.python_todo_rest_api.id}"
  resource_id   = "${aws_api_gateway_resource.get_update_delete_todo.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_update_delete_todo_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.python_todo_rest_api.id}"
  resource_id = "${aws_api_gateway_method.get_update_delete_todo_method.resource_id}"
  http_method = "${aws_api_gateway_method.get_update_delete_todo_method.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.get_update_delete_todo.invoke_arn}"
}


resource "aws_api_gateway_deployment" "get_update_delete_todo_deployment" {
  depends_on = [
    "aws_api_gateway_integration.get_update_delete_todo_integration",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.python_todo_rest_api.id}"
  stage_name  = "test"
}

output "get_update_delete_base_url" {
  value = "${aws_api_gateway_deployment.get_update_delete_todo_deployment.invoke_url}"
}