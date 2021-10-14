resource "aws_cognito_user_pool" "User-Pool" {
    name = "User-Pool-Cognito"
    alias_attributes = ["email", "phone_number"]
    auto_verified_attributes = ["email"]

    email_verification_message = "Hello, Welcome to service! please use the pass code {####} complete sign up."
    email_verification_subject = "Account invitation message subject"

    email_configuration {
        email_sending_account = "COGNITO_DEFAULT"
    }

    account_recovery_setting {
        recovery_mechanism {
            name = "verified_email"
            priority = 1
        }
    }

    password_policy {
        minimum_length = 8
        require_lowercase = true
        require_numbers = true 
        require_symbols = true     
        require_uppercase = true   
    }
}

resource "aws_cognito_user_pool_client" "User-Pool-Client" {
  name = "client"

  user_pool_id = aws_cognito_user_pool.User-Pool.id

  allowed_oauth_flows_user_pool_client = true 
  
  token_validity_units {
      access_token = "hours"
      id_token = "hours"
      refresh_token = "hours"
  }

  allowed_oauth_flows = ["code"]
  explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH"]
  allowed_oauth_scopes = ["email", "openid"]

  logout_urls = ["http://localhost/signout"]
  callback_urls = ["http://localhost/signout", "http://localhost/signin"]
}

resource "aws_cognito_user_pool_domain" "User-Pool-Client-Domain" {
  domain       = "testingappdomain-2021"
  user_pool_id = aws_cognito_user_pool.User-Pool.id
}

resource "aws_api_gateway_authorizer" "APIGW-Cognito-Authorizer" {
    name = "cognito_auth"
    type = "COGNITO_USER_POOLS"
    rest_api_id = aws_api_gateway_rest_api.Api-GW.id
    identity_source = "method.request.header.Authorization"
    provider_arns = ["${aws_cognito_user_pool.User-Pool.arn}"]
}
