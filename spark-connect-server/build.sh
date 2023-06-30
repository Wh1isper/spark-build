#!/usr/bin/env bash
cp -f ./spark-connector-server.Dockerfile ${SPARK_HOME}/Dockerfile.connector-server
cp -f ./start-server.sh ${SPARK_HOME}/start-server.sh
SPARK_VERSION="${SPARK_VERSION:=unknown-version}"
pushd ${SPARK_HOME}
docker build -t wh1isper/spark-connector-server:${SPARK_VERSION} -f Dockerfile.connector-server .
popd
