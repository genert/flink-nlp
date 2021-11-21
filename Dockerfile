FROM flink:1.14.0-scala_2.12-java11
ARG FLINK_VERSION=1.14.0

# Install PyFlink
RUN set -ex; \
    apt-get update; \
    apt-get -y install python3; \
    apt-get -y install python3-pip; \
    apt-get -y install python3-dev; \
    ln -s /usr/bin/python3 /usr/bin/python; \
    python -m pip install --upgrade pip; \
    pip install apache-flink==1.14.0;

# Download connector libraries
RUN wget -P /opt/flink/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-connector-jdbc_2.11/${FLINK_VERSION}/flink-connector-jdbc_2.11-${FLINK_VERSION}.jar

RUN echo "taskmanager.memory.jvm-metaspace.size: 512m" >> /opt/flink/conf/flink-conf.yaml;
RUN echo "taskmanager.memory.task.off-heap.size: 80mb" >> /opt/flink/conf/flink-conf.yaml;

WORKDIR /opt/flink
