clean:
	## removing the zip archive
	rm function.zip

build:
	## zip up the javascript file
	zip function.zip lambda.js

deploy: 
	
	## create a bucket on the localstack s3
	awslocal s3api create-bucket --bucket js-repository

	## copy the zipper up js file to the localstack s3
	awslocal s3 cp ./function.zip s3://js-repository/function.zip

	## deploy the cloudformation template
	awslocal cloudformation deploy --stack-name cfn-node-apig --template-file "./cfn-node-apig.yaml"