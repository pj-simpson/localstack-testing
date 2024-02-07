# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

"""
Purpose

Shows how to implement an AWS Lambda function that handles input from direct
invocation.
"""
def wait_for_debug_client(timeout=20):
    """Utility function to enable debugging with Visual Studio Code"""
    import time, threading
    import debugpy

    debugpy.listen(("0.0.0.0", 19891))
    class T(threading.Thread):
        daemon = True
        def run(self):
            time.sleep(timeout)
            print("Canceling debug wait task ...")
            debugpy.wait_for_client.cancel()
    T().start()
    print("Waiting for client to attach debugger ...")
    debugpy.wait_for_client()





def lambda_handler(event, context):
    """
    Accepts an action and a single number, performs the specified action on the number,
    and returns the result. The only allowable action is 'increment'.

    :param event: The event dict that contains the parameters sent when the function
                  is invoked.
    :param context: The context in which the function is called.
    :return: The result of the action.
    """
    wait_for_debug_client()

    result = None
    action = event.get('action')
    number = event.get('number', 0)
    print(f'the action is {action}')
    print(f'the number is {number}')
    if action == 'increment':
        result = number + 1
        print(f'the result is {result}')
    elif action == 'square':
        result = number * number
        print(f'the result is {result}')
    else:
        print('some kind fo error here')

    response = {'result': result}
    return response
# snippet-end:[python.example_code.lambda.handler.increment]