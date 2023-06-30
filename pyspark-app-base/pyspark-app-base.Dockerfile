FROM python:3.7.13-slim-buster
LABEL maintainer="wh1isper <9573586@qq.com>"


RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free" > /etc/apt/sources.list \
    && echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free" >> /etc/apt/sources.list \
    && echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free" >> /etc/apt/sources.list \
    && echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list \
    && apt-get -y update && apt-get -y upgrade && apt-get install -y curl default-jre \
    && rm -rf /var/lib/apt/lists/* &&  rm -rf /root/.cache && rm -rf /var/cache/apt/* \
    && rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && python3 -m pip install --upgrade pip -i https://mirrors.bfsu.edu.cn/pypi/web/simple \
    && pip3 install 'pyspark<3.3' grpcio grpcio_tools protobuf numpy pandas --no-cache-dir -i https://mirrors.bfsu.edu.cn/pypi/web/simple

# install s3 jars
# WORKDIR /tmp/pyspark_prepare
# COPY ./s3_jars /tmp/pyspark_prepare/s3_jars
# COPY ./install_s3_jars.py /tmp/pyspark_prepare/install_s3_jars.py
# RUN python3 install_s3_jars.py && rm -rf /tmp/pyspark_prepare/
ENV SPARK_HOME=/usr/local/lib/python3.7/site-packages/pyspark

ARG APPLICATION_UID=9999
ARG APPLICATION_GID=9999
RUN addgroup --system --gid ${APPLICATION_GID} application && \
    adduser --system --gid ${APPLICATION_GID} --home /home/application --uid ${APPLICATION_UID} --disabled-password application


# docker build -t wh1isper/pysparksampling-base -f application/dockerbuild/pysparksampling-base.Dockerfile .
