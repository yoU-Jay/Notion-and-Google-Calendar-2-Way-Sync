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

# Define the variables to be replaced in gcal.py
VAR1="DEFAULT_CALENDAR_ID"
VAR2="database_id"
VAR3="NOTION_TOKEN"
VAR4="urlRoot"

# Path to the Python file
FILE_PATH="home/ec2-user/notion-sync/Notion-and-Google-Calendar-2-Way-Sync/Notion-GCal-2WaySync-Public.py"

# Replace the variables in the Python file
sed -i.bak "s|$VAR1 = .*|$VAR1 = '$PARAM1_VALUE'|g" "$FILE_PATH"
sed -i.bak "s|$VAR2 = .*|$VAR2 = '$PARAM2_VALUE'|g" "$FILE_PATH"
sed -i.bak "s|$VAR3 = .*|$VAR3 = '$PARAM3_VALUE'|g" "$FILE_PATH"
sed -i.bak "s|$VAR4 = .*|$VAR4 = '$PARAM4_VALUE'|g" "$FILE_PATH"

# Optional: Remove backup file created by sed
rm "$FILE_PATH.bak"

echo "Values replaced successfully in $FILE_PATH"
