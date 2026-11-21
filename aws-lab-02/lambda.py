import json, os, urllib.request

def handler(event, context):
    queue_url = os.environ['QUEUE_URL']
    for record in event.get('Records', []):
        key = record['s3']['object']['key']
        body = json.dumps({'event': 'ObjectCreated', 'key': key}).encode()
        req = urllib.request.Request(queue_url, data=body, method='POST')
        req.add_header('Content-Type', 'application/x-amz-json-1.0')
        req.add_header('X-Amz-Target', 'AmazonSQS.SendMessage')
        try:
            urllib.request.urlopen(req, timeout=3)
        except Exception as e:
            print('sqs error', e)
    return {'status': 'ok'}
