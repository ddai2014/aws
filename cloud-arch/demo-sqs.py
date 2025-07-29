import boto3

SQS_QUEUE_NAME = "demo1"
sqs = boto3.resource('sqs')

# Get the queue by name
queue = sqs.get_queue_by_name(QueueName = SQS_QUEUE_NAME)
print(f"Processing messages from queue: {SQS_QUEUE_NAME}")

# Receive messages from the queue
for message in queue.receive_messages():
    print(f"Message: {message.body}")
    # message.delete()
