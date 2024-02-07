# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0
import boto3
"""
Purpose

Shows how to implement an AWS Lambda function that handles input from direct
invocation.
"""
def lambda_handler(event, context):
    """
    Accepts an action and a single number, performs the specified action on the number,
    and returns the result. The only allowable action is 'increment'.

    :param event: The event dict that contains the parameters sent when the function
                  is invoked.
    :param context: The context in which the function is called.
    :return: The result of the action.
    """
    client = boto3.client('events')

    result = None
    action = event.get('action')
    number = event.get('number', 0)
    print(f'the action is {action}')
    print(f'the number is {number}')
    if action == 'increment':
        result = number + 1
        client.put_events(Entries=[ { 'Source': 'increment-path', 'DetailType': 'testdetails', 'Detail': f'{ "result": "{result}" }', 'EventBusName': 'incrementbus' },])
    elif action == 'square':
        result = number * number
        client.put_events(Entries=[ { 'Source': 'square-path', 'DetailType': 'testdetails', 'Detail': f'{ "result": "{result}" }', 'EventBusName': 'incrementbus' },])
    else:
        client.put_events(Entries=[ { 'Source': 'error-path', 'DetailType': 'testdetails', 'Detail': '{ "result": "ERROR" }', 'EventBusName': 'incrementbus' },])

    response = {'result': result}
    return response
