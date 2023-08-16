#!/usr/bin/env bash
rm ${SPARK_HOME}/logs/*

cp -f ./spark-connector-server.Dockerfile ${SPARK_HOME}/Dockerfile.connector-server
cp -f ./start-server.sh ${SPARK_HOME}/start-server.sh
SPARK_VERSION="${SPARK_VERSION:=unknown-version}"
pushd ${SPARK_HOME}
docker buildx build -t wh1isper/spark-connector-server:${SPARK_VERSION} --platform linux/amd64,linux/arm64/v8 -f Dockerfile.connector-server --push .
popd
