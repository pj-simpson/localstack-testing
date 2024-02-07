build: 
	zip function.zip index.py

	awslocal lambda create-function \
		--function-name events-example \
		--runtime python3.11 \
		--zip-file fileb://function.zip \
		--handler index.handler \
		--role arn:aws:iam::000000000000:role/cool-stacklifter
	
	awslocal events put-rule \
    --name my-scheduled-rule \
    --schedule-expression 'rate(2 minutes)'

	awslocal lambda add-permission \
    --function-name events-example \
    --statement-id my-scheduled-event \
    --action 'lambda:InvokeFunction' \
    --principal events.amazonaws.com \
    --source-arn arn:aws:events:us-east-1:000000000000:rule/my-scheduled-rule

	awslocal events put-targets \
    --rule my-scheduled-rule \
    --targets file://targets.json