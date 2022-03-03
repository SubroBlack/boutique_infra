output "vpc_redis_output" {
    value = google_compute_network.vpc_network_redis
    description = "Output for the network self link"
}

