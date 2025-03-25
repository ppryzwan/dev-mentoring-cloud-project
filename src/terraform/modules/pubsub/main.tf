resource "google_pubsub_topic" "topics" {
  for_each = toset(var.topics)
  name     = "${var.topic_prefix}-${each.value}"

  message_retention_duration = var.message_retention_duration
}


resource "google_pubsub_subscription" "subscriptions" {
  for_each = toset(var.topics)

  name  = "${var.topic_prefix}-${each.value}-subscription"
  topic = google_pubsub_topic.topics[each.value].name

  ack_deadline_seconds = var.ack_deadline_seconds

  message_retention_duration = var.message_retention_duration
  retain_acked_messages      = var.retain_acked_messages

  depends_on = [google_pubsub_topic.topics]
}
