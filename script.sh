#!/bin/bash

# Define the SSM parameter names
PARAM1_NAME="/script_creds/calendar_id"
PARAM2_NAME="/script_creds/database_id"
PARAM3_NAME="/script_creds/notion_token"
PARAM4_NAME="/script_creds/urlRoot"

# Download parameters from SSM
PARAM1_VALUE=$(aws ssm get-parameter --name "$PARAM1_NAME" --with-decryption --query "Parameter.Value" --output text)
PARAM2_VALUE=$(aws ssm get-parameter --name "$PARAM2_NAME" --with-decryption --query "Parameter.Value" --output text)
PARAM3_VALUE=$(aws ssm get-parameter --name "$PARAM3_NAME" --with-decryption --query "Parameter.Value" --output text)
PARAM4_VALUE=$(aws ssm get-parameter --name "$PARAM4_NAME" --with-decryption --query "Parameter.Value" --output text)

export DEFAULT_CALENDAR_ID=$PARAM1_VALUE
export DATABASE_ID=$PARAM2_VALUE
export NOTION_TOKEN=$PARAM3_VALUE
export URL_ROOT=$PARAM4_VALUE

echo "Environment Variables are set!"
