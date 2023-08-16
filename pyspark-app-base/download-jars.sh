#!/usr/bin/env bash
set +e
set -x

JARS_DIR=$PWD/jars

mkdir -p $JARS_DIR
pushd $JARS_DIR
if [ ! -f spark-connect_2.12-3.4.1.jar ]
then
    wget http://42.193.219.110:8080/spark-connect_2.12-3.4.1.jar
else
    echo "Spark-connect found, skip download"
fi


if [ ! -f hadoop-3.3.4-share-hadoop-tools-lib.tar.gz ]
then
    wget http://42.193.219.110:8080/hadoop-3.3.4-share-hadoop-tools-lib.tar.gz
else
    echo "Hadoop tools found, skip download"
fi
    tar -zxvf hadoop-3.3.4-share-hadoop-tools-lib.tar.gz
    mv hadoop-3.3.4-tools-lib/* ./
    rm -rf hadoop-3.3.4-tools-lib
popd


echo "jars download finished"
