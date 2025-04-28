import os
import functions_framework
from flask import jsonify
from google.cloud import pubsub_v1


@functions_framework.http
def airPolutionTransform(request):
    if request.method != "POST":
        return jsonify({"error": "Only POST requests are accepted"}), 405
    subscription_path = os.environ.get("SUBSCRIPTION_PATH")

    if not subscription_path:
        return jsonify(
            {"error": "Missing required parameters. Ensure SUBSCRIPTION_PATH is set"}
        ), 400

    try:
        subscriber = pubsub_v1.SubscriberClient()
        response = subscriber.pull(
            request={"subscription": subscription_path, "max_messages": 1000}
        )
        ### It can be transformed etc, or other thing to ensure everything works
        if not response.received_messages:
            return jsonify({"message": "No messages to acknowledge", "count": 0})
        ack_ids = [msg.ack_id for msg in response.received_messages]
        subscriber.acknowledge(
            request={"subscription": subscription_path, "ack_ids": ack_ids}
        )
        subscriber.close()
        return jsonify(
            {"message": "Messages acknowledged successfully", "count": len(ack_ids)}
        )

    except Exception as e:
        return jsonify({"error": f"Error acknowledging messages: {str(e)}"}), 500
