clean:
	## removing the binary and the zip archive
	rm main
	rm function.zip

build:
	## build go function into binary
	GOOS=linux go build main.go

	## zip up the binary
	zip function.zip main

deploy: 
	## create a bucket on the localstack s3
	awslocal s3api create-bucket --bucket go-bin

	## copy the binary to the localstack s3
	awslocal s3 cp ./function.zip s3://go-bin/function.zip

	## deploy the cloudformation template
	awslocal cloudformation deploy --stack-name cfn-go-lamb --template-file "./cfn-go-lamb.yaml"

	## verify the lambda function url
	awslocal lambda get-function-url-config --function-name cfn-go-lamb