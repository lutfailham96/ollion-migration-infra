#!/bin/bash
DESTINATION_APP="new-app" # you can update this
ACCOUNT="123456789012" # use your own account ID
REGION="ap-southeast-3" # for Jakarta
aws ecr create-repository --repository-name ${DESTINATION_APP}
aws ecr get-login-password | docker login --username AWS --password-stdin ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com
