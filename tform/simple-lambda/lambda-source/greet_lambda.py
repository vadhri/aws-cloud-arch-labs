import os
import json

import boto3
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    record = {}
    method = event['httpMethod']
    
    print ('Event : ', method, event["queryStringParameters"])

    if method == "POST":
        requst_body = json.loads(event["body"])
        dynamodb = boto3.resource('dynamodb')
        table = dynamodb.Table('Dynamo-DB-Inventory')        
        
        response = table.put_item(Item = {
            "id": requst_body["id"],
            "manufacturer": requst_body["manufacturer"],
            "name": requst_body["name"],
            "releaseDate": requst_body["releaseDate"]
        })

        record = json.dumps({
                "name": "InsertedItem",
                "key": "OK"
            })

    elif method == "GET":
        dynamodb = boto3.resource('dynamodb')
        table = dynamodb.Table('Dynamo-DB-Inventory')        
        
        try:
            response = table.get_item(Key=event["queryStringParameters"])
            record = json.dumps({
                    "name": "GotAKey",
                    "key": response
                })            
        except ClientError as e:
            record = json.dumps({
                    "name": "Error",
                    "key": {}
                })                        

    return {
        "isBase64Encoded": False,
        "statusCode": 200,
        "headers": {  },
        "body": record
    }
