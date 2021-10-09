import os
import json

def lambda_handler(event, context):
    record = {}
    method = event['httpMethod']
    
    print ('Event : ', method, event["queryStringParameters"], event["body"])

    if method == "POST":
        record = json.dumps({
                "name": "POST Response",
                "key": event["body"]
            })
    elif method == "GET":
        record = json.dumps({
                "name": "GET Response",
                "key": event["queryStringParameters"]
            })

    return {
        "isBase64Encoded": False,
        "statusCode": 200,
        "headers": {  },
        "body": record
    }
