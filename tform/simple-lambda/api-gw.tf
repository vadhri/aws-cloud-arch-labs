resource "aws_api_gateway_rest_api" "Api-GW" {
    body = templatefile("api-spec/sample.json", {"lambda-inventory-get": aws_lambda_function.lambda.invoke_arn})
    name = "Registration-Service"
    
    endpoint_configuration {
      types = ["REGIONAL"]
      
    }
}

resource "aws_api_gateway_deployment" "Deployment-Config" {
  rest_api_id = aws_api_gateway_rest_api.Api-GW.id

  triggers = {
    redeployment = sha1(aws_api_gateway_rest_api.Api-GW.body)
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "staging" {
  deployment_id = aws_api_gateway_deployment.Deployment-Config.id
  rest_api_id   = aws_api_gateway_rest_api.Api-GW.id
  stage_name    = "staging"
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowMyDemoAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.Api-GW.execution_arn}/*/*/*"
}

