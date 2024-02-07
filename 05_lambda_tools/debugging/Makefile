clean:
	rm output.txt
	
deploy: 
	
	# create a bucket on the localstack s3
	awslocal s3api create-bucket --bucket hot-reload

	## create the function
	awslocal lambda create-function --function-name very-basic-python-func \
    --code S3Bucket="hot-reload",S3Key="/Users/petersimpson/Documents/losta/05_lambda_tools/debugging/" \
    --handler main.lambda_handler \
    --runtime python3.10 \
    --role arn:aws:iam::000000000000:role/lambda-role \
	--timeout 60

invoke:
	awslocal lambda invoke --function-name very-basic-python-func \
    --payload '{"action": "square", "number": 5}' \
    output.txt