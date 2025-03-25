import base64
import json
import functions_framework


@functions_framework.cloud_event
def subscribePubsub(cloud_event):
    pubsub_message = cloud_event.data.get("message", {})

    if "data" in pubsub_message:
        message_data = base64.b64decode(pubsub_message["data"]).decode("utf-8")
    else:
        message_data = None

    attributes = pubsub_message.get("attributes", {})
    message_id = pubsub_message.get("messageId", "unknown")

    try:
        if message_data:
            parsed_data = json.loads(message_data)
        return (
            f"Message processed successfully: {parsed_data}, {attributes}, {message_id}"
        )
    except Exception as e:
        print(f"Error processing message: {e}")
        raise e
