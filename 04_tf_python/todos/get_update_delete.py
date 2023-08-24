import os
import json
import logging
import time

import boto3

from aws_lambda_typing import context as context_, events, responses
from decimalencoder import DecimalEncoder


if 'LOCALSTACK_HOSTNAME' in os.environ:
    dynamodb_endpoint = 'http://%s:4566' % os.environ['LOCALSTACK_HOSTNAME']
    dynamodb = boto3.resource('dynamodb', endpoint_url=dynamodb_endpoint)
else:
    dynamodb = boto3.resource('dynamodb')

def get_or_update_or_delete_dispatcher(event: events.APIGatewayProxyEventV1, context: context_.Context) -> responses.APIGatewayProxyResponseV1:
    req_method = event['httpMethod']

    if req_method == 'GET':
        return get(event)
    elif req_method == 'PUT' or req_method == 'PATCH':
        return update(event)
    elif req_method == 'DELETE':
        return delete(event)
    else:
        response: responses.APIGatewayProxyResponseV1 = {
        "isBase64Encoded": False,
        "statusCode": 405,
        "body": ""
    }
        return response


def get(event: events.APIGatewayProxyEventV1)-> responses.APIGatewayProxyResponseV1:
    table = dynamodb.Table('python_todo_table')

    result = table.get_item(
        Key={
            'id': event['pathParameters']['id']
        }
    )
    response: responses.APIGatewayProxyResponseV1 = {
        "statusCode": 200,
        "body": json.dumps(result['Item'],
                           cls=DecimalEncoder)
    }

    return response

def delete(event: events.APIGatewayProxyEventV1) -> responses.APIGatewayProxyResponseV1:
    table = dynamodb.Table('python_todo_table')

    table.delete_item(
        Key={
            'id': event['pathParameters']['id']
        }
    )
    response: responses.APIGatewayProxyResponseV1 = {
        "statusCode": 204,
        "body": ""
    }

    return response

def update(event: events.APIGatewayProxyEventV1) -> responses.APIGatewayProxyResponseV1:
    data = json.loads(event['body'])
    if 'text' not in data or 'checked' not in data:
        logging.error("Validation Failed")
        raise Exception("Couldn't update the todo item.")
        return

    timestamp = int(time.time() * 1000)

    table = dynamodb.Table('python_todo_table')

    result = table.update_item(
        Key={
            'id': event['pathParameters']['id']
        },
        ExpressionAttributeNames={
          '#todo_text': 'text',
        },
        ExpressionAttributeValues={
          ':text': data['text'],
          ':checked': data['checked'],
          ':updatedAt': timestamp,
        },
        UpdateExpression='SET #todo_text = :text, '
                         'checked = :checked, '
                         'updatedAt = :updatedAt',
        ReturnValues='ALL_NEW',
    )

    response: responses.APIGatewayProxyResponseV1 = {
        "statusCode": 200,
        "body": json.dumps(result['Attributes'],
                           cls=DecimalEncoder)
    }

    return response