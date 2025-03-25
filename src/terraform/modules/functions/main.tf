data "archive_file" "weather_function" {
  type = "zip"

  output_path = "${var.path_weather_function}main.zip"

  source {
    content  = file("${var.path_weather_function}main.py")
    filename = "main.py"
  }

  source {
    content  = file("${var.path_weather_function}requirements.txt")
    filename = "requirements.txt"
  }

}


data "archive_file" "air_pollution_function" {
  type        = "zip"
  output_path = "${var.path_air_pollution_function}main.zip"

  source {
    content  = file("${var.path_air_pollution_function}main.py")
    filename = "main.py"
  }

  source {
    content  = file("${var.path_air_pollution_function}requirements.txt")
    filename = "requirements.txt"
  }
}

data "archive_file" "pubsub_function" {
  type        = "zip"
  output_path = "${var.path_pubsub_function}main.zip"
  source {
    content  = file("${var.path_pubsub_function}main.py")
    filename = "main.py"
  }

  source {
    content  = file("${var.path_pubsub_function}requirements.txt")
    filename = "requirements.txt"
  }
}

resource "google_storage_bucket_object" "weather_function" {
  name   = "${var.weather_function_name}.zip"
  source = data.archive_file.weather_function.output_path
  bucket = var.bucket_functions_name
}

resource "google_storage_bucket_object" "air_pollution_function" {
  name   = "${var.air_pollution_function_name}.zip"
  source = data.archive_file.air_pollution_function.output_path
  bucket = var.bucket_functions_name
}

resource "google_storage_bucket_object" "pubsub_function" {
  name   = "${var.pubsub_function_name}.zip"
  source = data.archive_file.pubsub_function.output_path
  bucket = var.bucket_functions_name
}



resource "google_cloudfunctions2_function" "weather_function" {
  name        = var.weather_function_name
  description = "Weather function"
  location    = var.region

  build_config {
    runtime     = var.runtime
    entry_point = var.weather_entry_point
    source {
      storage_source {
        bucket = var.bucket_functions_name
        object = google_storage_bucket_object.weather_function.name
      }
    }
  }

  service_config {
    available_memory = "256Mi"
    timeout_seconds  = 60
    environment_variables = {
      PUBSUB_TOPIC = var.weather_topic_name
      PROJECT_ID   = var.project_id
      API_KEY      = var.API_KEY
    }
  }
}


resource "google_cloudfunctions2_function" "air_pollution_function" {
  name        = var.air_pollution_function_name
  description = "Air pollution function"
  location    = var.region

  build_config {
    runtime     = var.runtime
    entry_point = var.air_pollution_entry_point
    source {
      storage_source {
        bucket = var.bucket_functions_name
        object = google_storage_bucket_object.air_pollution_function.name
      }
    }
  }

  service_config {
    available_memory = "256Mi"
    timeout_seconds  = 60
    environment_variables = {
      PUBSUB_TOPIC = var.polution_topic_name
      PROJECT_ID   = var.project_id
      API_KEY      = var.API_KEY
    }
  }
}

resource "google_cloudfunctions2_function" "pubsub_function" {
  for_each    = var.pubsub_topics
  name        = "${var.pubsub_function_name}_${each.key}"
  description = "PubSub subscriber function for ${each.key}"
  location    = var.region

  build_config {
    runtime     = var.runtime
    entry_point = var.pubsub_entry_point
    source {
      storage_source {
        bucket = var.bucket_functions_name
        object = google_storage_bucket_object.pubsub_function.name
      }
    }
  }

  service_config {
    available_memory = "256Mi"
    timeout_seconds  = 60
  }

  event_trigger {
    trigger_region = var.region
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = "projects/${var.project_id}/topics/${each.value}"
    retry_policy   = "RETRY_POLICY_RETRY"
  }
}
