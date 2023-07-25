# these are the shell commands utilising the localstack CLI 
# which could be used to manually do what the cloudformation template does

# create the lambda function
awslocal lambda create-function \
--function-name cfn-go-lamb \
--runtime go1.x \
--zip-file fileb://function.zip \
--handler lambo \
--role arn:aws:iam::000000000000:role/lambda-role

# assign a url to the lamdba function
awslocal lambda create-function-url-config \
--function-name cfn-go-lamb \
--auth-type NONE
d
# deploy the cloudformation template
awslocal cloudformation deploy --stack-name cfn-go-lamb --template-file "./cfn-go-lamb.yaml"

# verify the lambda function url (this isnt returned from the above command)
awslocal lambda get-function-url-config --function-name cfn-go-lamb