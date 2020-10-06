#!/bin/bash

# Install jq and update awscli
yum install jq -y
yum install python-pip -y
pip install awscli --upgrade

# Get Instance ID and Region
INSTANCE_ID=`curl http://169.254.169.254/latest/meta-data/instance-id 2>/dev/null`
REGION=`curl -s http://169.254.169.254/latest/dynamic/instance-identity/document 2>/dev/null | jq -r .region`

# Choose the leader Instance
LEADERINSTANCE=`aws deploy list-deployment-targets --deployment-id $DEPLOYMENT_ID --region $REGION --max-items 1000 | jq -r '.targetIds | .[]' | sort | head -1`

#check if the current instance is LEADERINSTANCE
if [ "$INSTANCE_ID" = "$LEADERINSTANCE" ]; then
  # your custom code goes here which should run only in one instance

  # below command I used to test the leader instance
  echo $DEPLOYMENT_ID >> /tmp/tempfile.txt
fi

