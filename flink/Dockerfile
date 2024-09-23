ARG FLINK_VERSION="FLINK_VERSION_IS_UNDEFINED"

FROM flink:${FLINK_VERSION}

USER root
RUN echo '#!/bin/sh' > /ex-docker-entrypoint.sh && \
    echo 'export FLINK_PROPERTIES=$(cat /opt/flink/conf/flink-properties.yml) && /docker-entrypoint.sh "$@"' >> /ex-docker-entrypoint.sh && \
    chmod +x /ex-docker-entrypoint.sh

#TODO: to remove, debug only
RUN apt update && apt install -y openjdk-11-jdk && rm -rf /var/lib/apt/lists/*

USER flink
RUN mkdir -p /opt/flink/data && \
    chmod -R 777 /opt/flink/data

ARG FLINK_VERSION_SHORT="FLINK_VERSION_SHORT_IS_UNDEFINED"
ARG HADOOP_VERSION="HADOOP_VERSION_IS_UNDEFINED"
ARG FLINK_HADOOP_VERSION="FLINK_HADOOP_VERSION_IS_UNDEFINED"
ARG AWS_SDK_VERSION="AWS_SDK_VERSION_IS_UNDEFINED"
ARG ICEBERG_VERSION="ICEBERG_VERSION_IS_UNDEFINED"

RUN curl -L https://github.com/knaufk/flink-faker/releases/download/v${FAKER_VERSION}/flink-faker-${FAKER_VERSION}.jar -o ${FLINK_HOME}/lib/flink-faker-${FAKER_VERSION}.jar

RUN curl -L https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-flink-runtime-${FLINK_VERSION_SHORT}/${ICEBERG_VERSION}/iceberg-flink-runtime-${FLINK_VERSION_SHORT}-${ICEBERG_VERSION}.jar \
   -o ${FLINK_HOME}/lib/iceberg-flink-runtime-${FLINK_VERSION_SHORT}-${ICEBERG_VERSION}.jar

RUN curl -L "https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-common/${HADOOP_VERSION}/hadoop-common-${HADOOP_VERSION}.jar" \
   -o ${FLINK_HOME}/lib/hadoop-common-${HADOOP_VERSION}.jar

RUN curl -L "https://repo.maven.apache.org/maven2/org/apache/flink/flink-shaded-hadoop-2-uber/${FLINK_HADOOP_VERSION}/flink-shaded-hadoop-2-uber-${FLINK_HADOOP_VERSION}.jar" \
   -o ${FLINK_HOME}/lib/flink-shaded-hadoop-2-uber-${FLINK_HADOOP_VERSION}.jar

RUN curl -L "https://repo1.maven.org/maven2/software/amazon/awssdk/bundle/${AWS_SDK_VERSION}/bundle-${AWS_SDK_VERSION}.jar" \
   -o ${FLINK_HOME}/lib/bundle-${AWS_SDK_VERSION}.jar

COPY flink-properties.yml /opt/flink/conf/

VOLUME /opt/flink/data

ENTRYPOINT [ "/ex-docker-entrypoint.sh" ]
