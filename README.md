
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Unused Topic Partition in Kafka
---

This incident type refers to the detection of an unused topic partition in Kafka Platform, a popular data streaming platform. Unused partitions can increase broker overhead and reduce efficiency, so it is recommended to delete them. The incident is triggered by a test notification or a monitoring query that checks the value of relevant metrics. The incident is resolved once the partition is deleted or confirmed to be intentional.

### Parameters
```shell
# Environment Variables

export TOPIC_NAME="PLACEHOLDER"

export KAFKA_BOOTSTRAP_SERVER="PLACEHOLDER"

export PARTITION_NUMBER="PLACEHOLDER"

export PARTITION_DIRECTORY="PLACEHOLDER"

export CONSUMER_GROUP="PLACEHOLDER"

export NUMBER_OF_THE_PARTITION="PLACEHOLDER"

export ZOOKEEPER_CONNECTION_STRING="PLACEHOLDER"

```

## Debug

### Check if the topic exists in the Kafka cluster
```shell
kafka-topics.sh --bootstrap-server ${KAFKA_BOOTSTRAP_SERVER} --describe --topic ${TOPIC_NAME}
```

### Check if the partition is marked as "unused"
```shell
kafka-log-dirs.sh --describe --topic-list ${TOPIC_NAME} --bootstrap-server ${KAFKA_BOOTSTRAP_SERVER} | grep -A 2 "${PARTITION_NUMBER}"
```

### Check the disk usage for the partition directory
```shell
du -sh ${PARTITION_DIRECTORY}
```

### Check the broker overhead for the partition
```shell
kafka-consumer-groups.sh --bootstrap-server ${KAFKA_BOOTSTRAP_SERVER} --describe --group ${CONSUMER_GROUP} --topic ${TOPIC_NAME}
```

### Check the status of the Kafka brokers
```shell
kafka-broker-api-versions.sh --bootstrap-server ${KAFKA_BOOTSTRAP_SERVER}
```

### Check the status of the ZooKeeper nodes
```shell
zkCli.sh -server $ZOOKEEPER_CONNECTION_STRING ls /brokers/ids
```

## Repair

### Delete the unused topic partition if it's no longer needed. You can use the Kafka command line tool to delete the topic partition.
```shell
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

```

# Delete the partition

$KAFKA_BIN/kafka-topics.sh --delete --topic $TOPIC --partitions $PARTITION

if [ $? -eq 0 ]

then

  echo "The partition $PARTITION of topic $TOPIC has been deleted."

else

  echo "Failed to delete the partition $PARTITION of topic $TOPIC. Check the logs for more information."

  exit 1

fi

exit 0

```