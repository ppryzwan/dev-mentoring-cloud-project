import base64
import json
import functions_framework
import os
from google.cloud import storage
from datetime import datetime
from utils import check_bucket


@functions_framework.cloud_event
def subscribePubsub(cloud_event):
    cloud_event_attributes = cloud_event._get_attributes()
    event_type = cloud_event_attributes["type"]
    event_source = cloud_event_attributes["source"]

    if "google.cloud.pubsub.topic.v1.messagePublished" == event_type:
        pubsub_message = cloud_event.data.get("message", {})
        if "data" in pubsub_message:
            message_data = base64.b64decode(pubsub_message["data"]).decode("utf-8")
        else:
            message_data = None
        message_id = pubsub_message.get("messageId", "unknown")

        try:
            if message_data:
                parsed_data = json.loads(message_data)
                # Send the message to the bucket after processing
                bucket_name = os.environ.get("BUCKET_NAME")
                topic = (
                    event_source.split("topics/")[1]
                    if "topics/" in event_source
                    else "unknown-topic"
                )
                if bucket_name:
                    timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
                    check_bucket(bucket_name=bucket_name, path=topic)
                    blob_name = f"{topic}/{timestamp}_{message_id}.json"
                    storage_client = storage.Client()
                    bucket = storage_client.get_bucket(bucket_name)
                    blob = bucket.blob(blob_name)
                    blob.upload_from_string(
                        message_data, content_type="application/json"
                    )

                return f"Message processed successfully: {parsed_data}, {message_id} - stored in {bucket_name}/{blob_name}"
            else:
                return f"Event type {event_type} not supported, but acknowledged"
        except Exception as e:
            raise e

    else:
        return f"Event type {event_type} not supported"
