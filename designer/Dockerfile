ARG NUSSKNACKER_VERSION="NUSSKNACKER_VERSION_IS_UNDEFINED"

FROM touk/nussknacker:${NUSSKNACKER_VERSION}_scala-2.12

ARG FLINK_VERSION="FLINK_VERSION_IS_UNDEFINED"
ARG FLINK_VERSION_SHORT="FLINK_VERSION_SHORT_IS_UNDEFINED"
ARG HADOOP_VERSION="HADOOP_VERSION_IS_UNDEFINED"
ARG FLINK_HADOOP_VERSION="FLINK_HADOOP_VERSION_IS_UNDEFINED"
ARG AWS_SDK_VERSION="AWS_SDK_VERSION_IS_UNDEFINED"
ARG ICEBERG_VERSION="ICEBERG_VERSION_IS_UNDEFINED"

USER root

RUN curl -L "https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-common/${HADOOP_VERSION}/hadoop-common-${HADOOP_VERSION}.jar" \
   -o /opt/nussknacker/lib/hadoop-common-${HADOOP_VERSION}.jar

RUN curl -L "https://repo.maven.apache.org/maven2/org/apache/flink/flink-shaded-hadoop-2-uber/${FLINK_HADOOP_VERSION}/flink-shaded-hadoop-2-uber-${FLINK_HADOOP_VERSION}.jar" \
   -o /opt/nussknacker/lib/flink-shaded-hadoop-2-uber-${FLINK_HADOOP_VERSION}.jar

RUN curl -L "https://repo1.maven.org/maven2/software/amazon/awssdk/bundle/${AWS_SDK_VERSION}/bundle-${AWS_SDK_VERSION}.jar" \
   -o /opt/nussknacker/lib/bundle-${AWS_SDK_VERSION}.jar

#RUN curl -L https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-flink-runtime-${FLINK_VERSION_SHORT}/${ICEBERG_VERSION}/iceberg-flink-runtime-${FLINK_VERSION_SHORT}-${ICEBERG_VERSION}.jar \
#   -o /opt/nussknacker/components/flink/extra/iceberg-flink-runtime-${FLINK_VERSION_SHORT}-${ICEBERG_VERSION}.jar
#RUN curl -L https://repository.apache.org/content/groups/snapshots/org/apache/iceberg/iceberg-flink-runtime-${FLINK_VERSION_SHORT}/1.7.0-SNAPSHOT/iceberg-flink-runtime-${FLINK_VERSION_SHORT}-${ICEBERG_VERSION}.jar \
#   -o /opt/nussknacker/components/flink/extra/iceberg-flink-runtime-${FLINK_VERSION_SHORT}-${ICEBERG_VERSION}.jar
COPY iceberg-flink-runtime-1.19-1.7.0-SNAPSHOT.jar /opt/nussknacker/components/flink/extra/

RUN chown -R demiourgos728:root /opt/nussknacker

USER demiourgos728
