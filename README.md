# WIP for [Epic: Overall upgrade](https://github.com/Wh1isper/pyspark-sampling-build/issues/1)

# Build for PySpark App

Current we build on Spark version: 3.4.1

Python as 3.10.x

> You can modify the build script and dockerfile to suit your Spark version and other needs

## Prepare

Nothing, we use pypi to install pyspark

# Build

```bash
cd pyspark-app-base
# Prepare your jars in ./pyspark-app-base/jars, see below:"(Optional) Adding Hadoop tools to Spark(eg. s3a ...)"
# Then build spark 3.4.1 with jars
docker build -t wh1isper/pyspark-app-base -f pyspark-app-base.Dockerfile .

```

# Build for Spark on K8S

Related: [spark-connect-server](./spark-connect-server),  [spark-executor](./spark-executor)

## Prepare

Requires Prebuild of Spark, download from [Spark download](https://spark.apache.org/downloads.html)

Current we build on Spark version 3.4.1

### Download Spark:

```bash
export SPARK_VERSION=3.4.1
wget https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz
# OR from my archive
wget https://bigdata-archive.obs.cn-south-222.ai.pcl.cn/spark-${SPARK_VERSION}-bin-hadoop3.tgz

```

### Unpack Spark and configure:

```bash
# May Need sudo
tar -zxvf spark-${SPARK_VERSION}-bin-hadoop3.tgz -C /opt 
mv /opt/spark-${SPARK_VERSION}-bin-hadoop3/ /opt/spark-${SPARK_VERSION}

export SPARK_HOME=/opt/spark-${SPARK_VERSION}
export PATH=${SPARK_HOME}/bin:${SPARK_HOME}/sbin:$PATH 
```

### Verified

```bash
spark-shell
```

### (Optional) Adding Hadoop tools to Spark(eg. s3a ...)

ATTENTION: There are packages in Hadoop that may be lower than Spark's version and need to be removed

> In Spark 3.4.1 + hadoop 3.3.4: These two packages are out of date
> zstd-jni-1.4.9-1.jar
> lz4-java-1.7.1.jar

#### From my archive

```bash
wget https://bigdata-archive.obs.cn-south-222.ai.pcl.cn/hadoop-3.3.4-share-hadoop-tools-lib.tar.gz
tar -zxvf hadoop-3.3.4-share-hadoop-tools-lib.tar.gz
mv hadoop-3.3.4-tools-lib/* ${SPARK_HOME}/jars/
```

#### Official way to get hadoop tools

1 Find the specific version of hadoop used by Spark

```bash
ls $SPARK_HOME/jars | grep hadoop
```

> hadoop-{package_name}-{version}.jar
> eg. hadoop-client-3.3.4.jar means hadoop version 3.3.4

2 Download hadoop, 3.3.4 as example

```bash
export HADOOP_VERSION=3.3.4
wget https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz 
tar xvzf hadoop-*.tar.gz 
mv hadoop-${HADOOP_VERSION} /opt/hadoop
export HADOOP_HOME=/opt/hadoop
```

3 Copy tools to spark jars

```bash
cp ${HADOOP_HOME}/share/hadoop/tools/lib/* ${SPARK_HOME}/jars/
```

### (Optional) Download spark-connect jar

Spark will be downloaded automatically, if the deployment environment does not have network, please download it first and then use it.

```bash
cd $SPARK_HOME/jars
wget https://repo1.maven.org/maven2/org/apache/spark/spark-connect_${SCALA_VERSION}/${SPARK_VERSION}/spark-connect_${SCALA_VERSION}-${SPARK_VERSION}.jar
```

## Build

### Require

Need env: SPARK_HOME

Optional env: SPARK_VERSION

### Build Connect-server

> You can modify the start-server.sh to suit your Spark version and other needs

```bash
pushd spark-connect-server
./build
popd
```

Run:

```bash
docker run -it --rm \
-p 15002:15002 \
-p 4040:4040 \
wh1isper/spark-connector-server:3.4.1
```

Test with pyspark

```bash
pyspark --remote "sc://localhost:15002"
```

Code example

```python
from datetime import datetime, date
from pyspark.sql import Row

df = spark.createDataFrame([
    Row(a=1, b=2., c='string1', d=date(2000, 1, 1), e=datetime(2000, 1, 1, 12, 0)),
    Row(a=2, b=3., c='string2', d=date(2000, 2, 1), e=datetime(2000, 1, 2, 12, 0)),
    Row(a=4, b=5., c='string3', d=date(2000, 3, 1), e=datetime(2000, 1, 3, 12, 0))
])
df.show()
```

### Build executor

```bash
pushd spark-executor
./build
popd
```
