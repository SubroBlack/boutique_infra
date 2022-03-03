output "Redis_host" {
  description = "The IP address of the Redis instance."
  value       = google_redis_instance.Redis.host
}