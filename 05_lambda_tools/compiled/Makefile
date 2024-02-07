clean:
	## removing the binary and the zip archive
	rm lambda_handler_basic
	rm function.zip
	rm output.txt

build:
	## build go function into binary
	GOOS=linux go build lambda_handler_basic.go

	## zip up the binary
	zip function.zip lambda_handler_basic

rebuild: clean build

deploy: 
	## create the hot reload bucket on the localstack s3
	awslocal s3api create-bucket --bucket hot-reload

	## copy the binary to the localstack s3
	awslocal s3 cp ./function.zip s3://hot-reload/function.zip

	## create the function
	awslocal lambda create-function --function-name very-basic-go-func\
    --code S3Bucket="hot-reload",S3Key="/Users/petersimpson/Documents/losta/05_lambda_tools/compiled" \
    --handler lambda_handler_basic \
    --runtime go1.x \
    --zip-file fileb://function.zip \
    --role arn:aws:iam::000000000000:role/lambda-role

invoke:

	## invoke the function
	awslocal lambda invoke --function-name very-basic-go-func\
    --payload '{"name": "Peter"}' \
    output.txt