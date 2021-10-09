import os
import json

def lambda_handler(event, context):

    record = json.dumps({
            "name": "ABCD",
            "key": "test-key-id"
        })

    return {
        "isBase64Encoded": False,
        "statusCode": 200,
        "headers": {  },
        "body": record
    }
