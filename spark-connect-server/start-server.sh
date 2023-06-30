#!/usr/bin/env bash
SPARK_VERSION=3.4.1
SCALA_VERSION=2.12

# TODO Support on k8s
SPARK_CONNECT_SERVER_PORT="${SPARK_CONNECT_SERVER_PORT:=15002}"

/opt/spark/sbin/start-connect-server.sh \
--conf spark.connect.grpc.binding.port=$SPARK_CONNECT_SERVER_PORT

tail -f /opt/spark/logs/*