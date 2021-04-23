all:
	aws --region us-west-2 cloudformation deploy --template-file firehose.yml --stack-name kfh-example --parameter-overrides Environment=dev --capabilities CAPABILITY_IAM
