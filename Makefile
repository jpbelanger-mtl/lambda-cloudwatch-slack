
LAMBDA_TEST?=./node_modules/node-lambda/bin/node-lambda
LAMBDA_FUNCTION_NAME=slack-cloudwatch-notification
AWS_REGION=us-east-1
AWS_ROLE=arn:aws:iam::439003375788:role/lambda_basic_execution
AWS_PROFILE=test-appdirect

all:
	npm build

.PHONY: deps
deps:
	npm install

.PHONY: test
test:
	AWS_REGION=$(AWS_REGION) $(LAMBDA_TEST) run -f test/config.properties -x test/context.json -j test/sns-cloudwatch-event.json
	AWS_REGION=$(AWS_REGION) $(LAMBDA_TEST) run -f test/config.properties -x test/context.json -j test/sns-elastic-beanstalk-event.json
	AWS_REGION=$(AWS_REGION) $(LAMBDA_TEST) run -f test/config.properties -x test/context.json -j test/sns-codedeploy-event.json
	AWS_REGION=$(AWS_REGION) $(LAMBDA_TEST) run -f test/config.properties -x test/context.json -j test/sns-codedeploy-configuration.json
	AWS_REGION=$(AWS_REGION) $(LAMBDA_TEST) run -f test/config.properties -x test/context.json -j test/sns-elasticache-event.json
	AWS_REGION=$(AWS_REGION) $(LAMBDA_TEST) run -f test/config.properties -x test/context.json -j test/sns-autoscaling-event.json

.PHONY: package
package:
	$(LAMBDA_TEST) package --functionName $(LAMBDA_FUNCTION_NAME) --packageDirectory $(LAMBDA_FUNCTION_NAME)

.PHONY: deploy
deploy:
	$(LAMBDA_TEST) deploy --functionName $(LAMBDA_FUNCTION_NAME) \
				--role $(AWS_ROLE) \
				--accessKey $(AWS_ACCESS_KEY_ID) \
				--secretKey $(AWS_ACCESS_KEY_SECRET) \
				--region $(AWS_REGION) \
				--profile $(AWS_PROFILE)
