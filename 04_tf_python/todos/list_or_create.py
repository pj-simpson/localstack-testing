import json
import os
import logging
import time
import uuid


from decimalencoder import DecimalEncoder
from aws_lambda_typing import context as context_, events, responses

import boto3

if 'LOCALSTACK_HOSTNAME' in os.environ:
    dynamodb_endpoint = 'http://%s:4566' % os.environ['LOCALSTACK_HOSTNAME']
    dynamodb = boto3.resource('dynamodb', endpoint_url=dynamodb_endpoint)
else:
    dynamodb = boto3.resource('dynamodb')


def list_or_create_dispatcher(event: events.APIGatewayProxyEventV1, context: context_.Context) -> responses.APIGatewayProxyResponseV1:
    req_method = event['httpMethod']

    if req_method == 'GET':
        return list()
    elif req_method == 'POST':
        return create(event)
    else:
        response: responses.APIGatewayProxyResponseV1 = {
        "isBase64Encoded": False,
        "statusCode": 405,
        "body": ""
    } 
        return response
    


def list() -> responses.APIGatewayProxyResponseV1:
    table = dynamodb.Table('python_todo_table')

    result = table.scan()

    response: responses.APIGatewayProxyResponseV1 = {
        "isBase64Encoded": False,
        "statusCode": 200,
        "body": json.dumps(result['Items'], cls=DecimalEncoder)
    }


    return response

def create(event: events.APIGatewayProxyEventV1) -> responses.APIGatewayProxyResponseV1:
    data = json.loads(event['body'])
    if 'text' not in data:
        logging.error("Validation Failed")
        raise Exception("Couldn't create the todo item.")
    
    timestamp = str(time.time())

    table = dynamodb.Table('python_todo_table')

    item = {
        'id': str(uuid.uuid1()),
        'text': data['text'],
        'checked': False,
        'createdAt': timestamp,
        'updatedAt': timestamp,
    }

    table.put_item(Item=item)

    response: responses.APIGatewayProxyResponseV1 = {
        "statusCode": 201,
        "body": json.dumps(item)
    }

    return response