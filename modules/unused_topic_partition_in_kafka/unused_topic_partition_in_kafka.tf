resource "shoreline_notebook" "unused_topic_partition_in_kafka" {
  name       = "unused_topic_partition_in_kafka"
  data       = file("${path.module}/data/unused_topic_partition_in_kafka.json")
  depends_on = [shoreline_action.invoke_delete_topic_partition]
}

resource "shoreline_file" "delete_topic_partition" {
  name             = "delete_topic_partition"
  input_file       = "${path.module}/data/delete_topic_partition.sh"
  md5              = filemd5("${path.module}/data/delete_topic_partition.sh")
  description      = "Delete the unused topic partition if it's no longer needed. You can use the Kafka command line tool to delete the topic partition."
  destination_path = "/agent/scripts/delete_topic_partition.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_delete_topic_partition" {
  name        = "invoke_delete_topic_partition"
  description = "Delete the unused topic partition if it's no longer needed. You can use the Kafka command line tool to delete the topic partition."
  command     = "`chmod +x /agent/scripts/delete_topic_partition.sh && /agent/scripts/delete_topic_partition.sh`"
  params      = ["NUMBER_OF_THE_PARTITION","TOPIC_NAME","ZOOKEEPER_CONNECTION_STRING"]
  file_deps   = ["delete_topic_partition"]
  enabled     = true
  depends_on  = [shoreline_file.delete_topic_partition]
}

