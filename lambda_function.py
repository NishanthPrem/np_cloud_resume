import json
import boto3
from botocore.exceptions import ClientError

# Initialize DynamoDB resource
dynamo_db = boto3.resource('dynamodb')

def lambda_handler(event, context):
    table_name = "np-cloud-resume-db"
    table = dynamo_db.Table(table_name)
    counter_id = 'visitor_count'  # A unique ID to store the visitor count

    try:
        # Fetch the current count (if exists)
        response = table.get_item(Key={'id': counter_id})
        if 'Item' in response:
            visit_count = response['Item']['count']
        else:
            # Initialize the counter if it doesn't exist
            visit_count = 0
        
        # Increment the counter
        visit_count += 1
        
        # Update the counter in DynamoDB
        table.put_item(Item={'id': counter_id, 'count': visit_count})

        return {
            'statusCode': 200,
            'body': json.dumps(f"Visitor count updated: {visit_count}")
        }
    
    except ClientError as e:
        return {
            'statusCode': 400,
            'body': json.dumps(f"Error updating visitor count: {e.response['Error']['Message']}")
        }
