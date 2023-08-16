FROM python:3.10.12-slim-bookworm
LABEL maintainer="wh1isper <9573586@qq.com>"

RUN  apt-get -y update && apt-get -y upgrade && apt-get install -y curl default-jre \
    && rm -rf /var/lib/apt/lists/* &&  rm -rf /root/.cache && rm -rf /var/cache/apt/*
# SET timezone if needed
# RUN rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

ARG APPLICATION_UID=9999
ARG APPLICATION_GID=9999
RUN addgroup --system --gid ${APPLICATION_GID} application && \
    adduser --system --gid ${APPLICATION_GID} --home /home/application --uid ${APPLICATION_UID} --disabled-password application

USER application
ARG SPARK_VERSION=3.4.1
ENV SPARK_VERSION=${SPARK_VERSION}

RUN python3 -m pip install --upgrade pip \
    && pip3 install "pyspark[pandas_on_spark,connect,sql]==${SPARK_VERSION}" plotly --no-cache-dir
ENV PATH=/home/application/.local/bin:$PATH
# install s3 jars
WORKDIR /tmp/prepare
COPY --chown=9999:9999 ./jars/*.jar /tmp/prepare/jars/
COPY ./install_jars.py /tmp/prepare/install_jars.py
RUN python3 install_jars.py && rm -rf /tmp/prepare/
ENV SPARK_HOME=/home/application/.local/lib/python3.10/site-packages/pyspark
WORKDIR /home/application

# SPARK_VERSION=3.4.1;docker buildx build -t wh1isper/pyspark-app-base:${SPARK_VERSION} --platform linux/amd64,linux/arm64/v8 -f pyspark-app-base.Dockerfile --build-arg SPARK_VERSION=${SPARK_VERSION} --push .
