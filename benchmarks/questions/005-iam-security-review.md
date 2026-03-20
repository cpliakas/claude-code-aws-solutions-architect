Our Lambda function uses this IAM policy. Can you review it for security issues?

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
```

The function only needs to read objects from a specific S3 bucket (arn:aws:s3:::my-app-data) and write to a DynamoDB table (arn:aws:dynamodb:us-east-1:123456789:table/Orders).
