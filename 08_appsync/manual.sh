awslocal dynamodb create-table \
    --table-name DynamoDBPostsTable \
    --attribute-definitions AttributeName=Id,AttributeType=S \
    --key-schema AttributeName=Id,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST

awslocal appsync create-graphql-api \
    --name PostsApi \
    --authentication-type API_KEY

API_ID=$(awslocal appsync list-graphql-apis | jq -r '(.graphqlApis[] | select(.name=="test-api")).apiId')

API_KEY=$(awslocal appsync create-api-key --api-id $api_id | jq -r .apiKey.id)

awslocal appsync start-schema-creation \
    --api-id $API_ID \
    --definition file://schema.graphql

awslocal appsync create-data-source \
    --name AppSyncDB \
    --api-id $API_ID  \
    --type AMAZON_DYNAMODB \
    --dynamodb-config tableName=DynamoDBPostsTable,awsRegion=us-east-1

awslocal appsync create-resolver \
    --api-id $API_ID  \
    --type Mutation \
    --field addPostsDDB \
    --data-source-name AppSyncDB \
    --request-mapping-template file://ddb.PutItem.request.vlt \
    --response-mapping-template file://ddb.PutItem.response.vlt

awslocal appsync create-resolver \
    --api-id $API_ID  \
    --type Query \
    --field getPostsDDB \
    --data-source-name AppSyncDB \
    --request-mapping-template file://ddb.Scan.request.vlt \
    --response-mapping-template file://ddb.Scan.response.vlt

echo $API_KEY



