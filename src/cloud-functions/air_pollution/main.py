import requests
import json
import os
import functions_framework
from geopy.geocoders import Nominatim
from flask import jsonify
from google.cloud import pubsub_v1
from utils import get_secret


@functions_framework.http
def getPolution(request):
    env_vars = {key: value for key, value in os.environ.items()}
    api_url = "http://api.openweathermap.org/data/2.5/air_pollution?"
    try:
        if request.method == "POST":
            body_params = request.get_json()
            address_data = body_params.get("address", "Warszawa")
            geolocator = Nominatim(user_agent="weather-agent")
            location = geolocator.geocode(address_data)
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
            try:
                params = {
                    "lat": round(location.latitude, 4),
                    "lon": round(location.longitude, 4),
                    "appid": env_vars.get("API_KEY"),
                }
                response = requests.get(api_url, params=params)
                if response.status_code in [401, 403]:
                    raise Exception("Invalid API key")
                response.raise_for_status()
            except Exception:
                try:
                    backup_api_key = get_secret("API-weather", project_id)
                    params = {
                        "lat": round(location.latitude, 4),
                        "lon": round(location.longitude, 4),
                        "appid": backup_api_key,
                    }
                    response = requests.get(api_url, params=params)
                    response.raise_for_status()
                except Exception as e:
                    return jsonify(
                        {
                            "error": "Error getting data from API",
                            "message": str(e),
                        },
                        500,
                    )
            air_data = response.json()
            quality_names = {
                1: "good",
                2: "fair",
                3: "moderate",
                4: "poor",
                5: "very poor",
            }

            returned_data = {
                "address": address_data,
                "location_lattitude": air_data["coord"]["lat"],
                "location_longitude": air_data["coord"]["lon"],
                "air_pollution": {
                    "qualitive_name": quality_names[air_data["list"][0]["main"]["aqi"]],
                    "co": air_data["list"][0]["components"]["co"],
                    "no": air_data["list"][0]["components"]["no"],
                    "no2": air_data["list"][0]["components"]["no2"],
                    "o3": air_data["list"][0]["components"]["o3"],
                    "so2": air_data["list"][0]["components"]["so2"],
                    "pm10": air_data["list"][0]["components"]["pm10"],
                    "pm2_5": air_data["list"][0]["components"]["pm2_5"],
                },
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
#Testing the script
