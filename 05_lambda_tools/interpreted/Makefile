build:
	## create the hot reload bucket
	awslocal s3api create-bucket --bucket hot-reload

deploy: 
	## create the function
	awslocal lambda create-function --function-name very-basic-ruby-func \
    --code S3Bucket="hot-reload",S3Key="$(pwd)" \
    --handler lambda_handler_basic.lambda_handler \
    --runtime ruby3.2 \
    --role arn:aws:iam::000000000000:role/lambda-role

invoke:
	awslocal lambda invoke --function-name very-basic-ruby-func \
    --payload '{"action": "square", "number": 5}' \
    output.txt