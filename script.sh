#!/bin/bash

# Define the SSM parameter names
PARAM1_NAME="/script_creds/calendar_id"
PARAM2_NAME="/script_creds/database_id"
PARAM3_NAME="/script_creds/notion_token"
PARAM4_NAME="/script_creds/urlRoot"
PARAM5_NAME="/script_creds/token"

# Download parameters from SSM
PARAM1_VALUE=$(aws ssm get-parameter --name "$PARAM1_NAME" --with-decryption --query "Parameter.Value" --output text)
PARAM2_VALUE=$(aws ssm get-parameter --name "$PARAM2_NAME" --with-decryption --query "Parameter.Value" --output text)
PARAM3_VALUE=$(aws ssm get-parameter --name "$PARAM3_NAME" --with-decryption --query "Parameter.Value" --output text)
PARAM4_VALUE=$(aws ssm get-parameter --name "$PARAM4_NAME" --with-decryption --query "Parameter.Value" --output text)
S3_URI=$(aws ssm get-parameter --name "$PARAM5_NAME" --query "Parameter.Value" --output text)

#Setting Environment Variables
export DEFAULT_CALENDAR_ID=$PARAM1_VALUE
export DATABASE_ID=$PARAM2_VALUE
export NOTION_TOKEN=$PARAM3_VALUE
export URL_ROOT=$PARAM4_VALUE
echo "Environment Variables are set!"

#Downloading token.pkl
echo "Downloading token.pkl"

download_from_s3() {
    local s3_uri="$1"
    local local_file="$2"

    # Extract bucket and object from S3 URI
    if [[ $s3_uri == s3://* ]]; then
        BUCKET=$(echo $s3_uri | awk -F/ '{print $3}')
        OBJECT=$(echo $s3_uri | sed 's@s3://'$BUCKET'/@@')

        # Download file from S3
        aws s3 cp s3://$BUCKET/$OBJECT $local_file
        return $?
    else
        echo "Invalid S3 URI format: $s3_uri"
        exit 1
    fi
}

if [ -z "$S3_URI" ]; then
    echo "Failed to fetch S3 URI from Parameter Store"
    exit 1
fi
# Download file from S3 and save as token.pkl
download_from_s3 "$S3_URI" "token.pkl"

# Check download status
if [ $? -eq 0 ]; then
    echo "File downloaded successfully: token.pkl"
else
    echo "Failed to download file from S3"
    exit 1
fi

python3 Notion-GCal-2WaySync-Public.py
