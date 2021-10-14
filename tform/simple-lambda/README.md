The following will be deployed to the account with cred in .aws folder ofthe host machine (or other terraform access methods like env).
- A lambda function. 
- An API gateway linked to the lambda function authorized by cognito user pool tokens. 
    - GET
    - POST
- A cognito user pool 
- A dynamo db used by the lambda function. 

A sample client for cognito in react-js has two simple forms for sign in and sign up. 