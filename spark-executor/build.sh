#!/usr/bin/env bash
rm ${SPARK_HOME}/logs/*

cp -f ./spark-executor.Dockerfile ${SPARK_HOME}/Dockerfile.executor
SPARK_VERSION="${SPARK_VERSION:=unknown-version}"
pushd ${SPARK_HOME}
docker build -t wh1isper/spark-executor:${SPARK_VERSION} -f Dockerfile.executor .
popd