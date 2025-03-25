import requests
import json
import os
import functions_framework
from geopy.geocoders import Nominatim
from flask import jsonify
from datetime import datetime
from google.cloud import pubsub_v1


@functions_framework.http
def getWeather(request):
    env_vars = {key: value for key, value in os.environ.items()}
    try:
        if request.method == "GET":
            query_params = request.args
            address_data = query_params.get("address", "Warszawa")

            geolocator = Nominatim(user_agent="weather-agent")
            location = geolocator.geocode(address_data)

            api_url = "https://api.openweathermap.org/data/2.5/weather?"
            project_id = os.environ.get("PROJECT_ID")
            topic_name = os.environ.get("PUBSUB_TOPIC")
            if not project_id or not topic_name:
                return jsonify(
                    {
                        "error": "Configuration error",
                        "message": "PROJECT_ID and PUBSUB_TOPIC environment variables must be set",
                    },
                    500,
                )

            publisher = pubsub_v1.PublisherClient()
            topic_path = publisher.topic_path(project_id, topic_name)
            params = {
                "lat": round(location.latitude, 4),
                "lon": round(location.longitude, 4),
                "units": "metric",
                "appid": env_vars.get("API_KEY"),
            }
            response = requests.get(api_url, params=params)
            weather_data = response.json()
            now = datetime.now().isoformat()
            returned_data = {
                "address": address_data,
                "location_lattitude": weather_data["coord"]["lat"],
                "location_longitude": weather_data["coord"]["lon"],
                "weather": {
                    "temperature": weather_data["main"]["temp"],
                    "humidity": weather_data["main"]["humidity"],
                    "pressure": weather_data["main"]["pressure"],
                    "temp_max": weather_data["main"]["temp_max"],
                    "temp_min": weather_data["main"]["temp_min"],
                    "weather_description": weather_data["weather"][0]["description"],
                },
                "datetime": now,
            }
            message_data = json.dumps(returned_data).encode("utf-8")
            future = publisher.publish(topic_path, message_data)
            message_id = future.result()
            return jsonify(
                {
                    "status": "success",
                    "message": f"Message published to {topic_name}",
                    "messageId": message_id,
                },
                200,
            )
        else:
            return jsonify(
                {
                    "error": "Method not allowed",
                    "message": f"The {request.method} is not allowed for this endpoint",
                }
            ), 405
    except Exception as e:
        return jsonify({"error": "Something went wrong", "message": str(e)}), 500
