#!/bin/bash

# Set the variables

TOPIC=${TOPIC_NAME}

PARTITION=${NUMBER_OF_THE_PARTITION}

ZOOKEEPER=${ZOOKEEPER_CONNECTION_STRING}

# Stop the Kafka broker

/bin/kafka-server-stop.sh

# Delete the topic partition

/bin/kafka-topics.sh --delete --zookeeper $ZOOKEEPER --topic $TOPIC --partition $PARTITION

# Start the Kafka broker

/bin/kafka-server-start.sh