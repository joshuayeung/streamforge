#!/bin/bash

# Kafka cluster configuration
BROKER="your-broker-address:9092" # Replace with your Kafka MSK broker address
TOPIC_TWITTER="twitter-stream"
TOPIC_REDDIT="reddit-stream"

# Create Kafka topics
create_topic() {
  local topic=$1
  local partitions=$2
  local replication_factor=$3

  echo "Creating topic: $topic"
  kafka-topics --create --topic "$topic" --partitions "$partitions" --replication-factor "$replication_factor" --bootstrap-server "$BROKER" --if-not-exists
}

# Setup Twitter topic
create_topic "$TOPIC_TWITTER" 3 2 # 3 partitions, replication factor of 2

# Setup Reddit topic
create_topic "$TOPIC_REDDIT" 3 2 # 3 partitions, replication factor of 2

echo "Kafka topics setup completed."
