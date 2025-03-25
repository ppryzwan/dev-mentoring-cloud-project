output "topic_names" {
  description = "The names of the Pub/Sub topics"
  value       = { for k, v in google_pubsub_topic.topics : k => v.name }
}

output "topic_ids" {
  description = "The IDs of the Pub/Sub topics"
  value       = { for k, v in google_pubsub_topic.topics : k => v.id }
}

output "subscription_names" {
  description = "The names of the Pub/Sub subscriptions"
  value       = { for k, v in google_pubsub_subscription.subscriptions : k => v.name }
}

output "subscription_ids" {
  description = "The IDs of the Pub/Sub subscriptions"
  value       = { for k, v in google_pubsub_subscription.subscriptions : k => v.id }
}
