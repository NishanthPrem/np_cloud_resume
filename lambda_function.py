import json
import boto3
from botocore.exceptions import ClientError
from decimal import Decimal

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
            visit_count = int(response['Item']['count'])  # Convert Decimal to int
        else:
            # Initialize the counter if it doesn't exist
            visit_count = 0
        
        # Increment the counter
        visit_count += 1
        
        # Update the counter in DynamoDB
        table.put_item(Item={'id': counter_id, 'count': Decimal(visit_count)})

        # Return the visitor count with CORS headers
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': '*',  # Allow all origins
                'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',  # Allowed methods
                'Access-Control-Allow-Headers': 'Content-Type'  # Allowed headers
            },
            'body': json.dumps({'visitorCount': visit_count})
        }
    
    except ClientError as e:
        # Return error response with CORS headers
        return {
            'statusCode': 400,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
                'Access-Control-Allow-Headers': 'Content-Type'
            },
            'body': json.dumps({'error': f"Error updating visitor count: {e.response['Error']['Message']}"})
        }
