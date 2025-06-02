import json
import boto3
import os
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['DYNAMODB_TABLE'])

def lambda_handler(event, context):
    for record in event['Records']:
        s3_info = record['s3']
        bucket = s3_info['bucket']['name']
        key = s3_info['object']['key']
        size = s3_info['object']['size']
        
        table.put_item(Item={
            'photo_name': key,
            'upload_time': datetime.utcnow().isoformat(),
            'size': size
        })

    return {
        'statusCode': 200,
        'body': json.dumps('Metadata stored in DynamoDB')
    }
