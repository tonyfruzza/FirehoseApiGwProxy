STACK_NAME=kfh-example
REGION=us-west-2

aws --region $REGION cloudformation deploy --template-file firehose.yml --stack-name $STACK_NAME --parameter-overrides Environment=dev --capabilities CAPABILITY_IAM
API_GW_ENDPOINT=$(aws --region $REGION cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[0].Outputs[?OutputKey == `ServiceEndpoint`].{out:OutputValue}' --output text)
FIREHOSE_NAME=$(aws --region $REGION cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[0].Outputs[?OutputKey == `Firehose`].{out:OutputValue}' --output text)


echo "Adding data to Firehose stream: $FIREHOSE_NAME"

curl -H "Content-Type: application/json" -X POST $API_GW_ENDPOINT -d "
{
    \"DeliveryStreamName\": \"$FIREHOSE_NAME\",
    \"Record\": {
        \"Data\": \"SampleDataStringToFirehose\"
    }
}"
