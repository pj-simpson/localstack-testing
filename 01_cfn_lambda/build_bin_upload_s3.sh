# build go function into binary
GOOS=linux go build main.go

# zip up the binary
zip function.zip main

# create a bucket on the localstack s3
awslocal s3api create-bucket --bucket go-bin

# copy the binary to the localstack s3
awslocal s3 cp ./function.zip s3://go-bin/function.zip