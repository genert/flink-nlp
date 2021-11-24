FROM flink:1.13.1-scala_2.11-java11
ARG FLINK_VERSION=1.13.1

# Install Python    
RUN set -ex; \
    apt-get update; \
    apt-get install -y python3 python3-pip python3-dev; \
    rm -rf /var/lib/apt/lists/*; \
    ln -s /usr/bin/python3 /usr/bin/python;

# Install PyFlink and Spacy
RUN pip3 install -U setuptools wheel; \
    pip3 install -U apache-flink==1.13.1; \
    pip3 install -U spacy; \
    python -m spacy download en_core_web_md;

# Download connector libraries
RUN wget -P /opt/flink/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-connector-jdbc_2.11/${FLINK_VERSION}/flink-connector-jdbc_2.11-${FLINK_VERSION}.jar

RUN echo "taskmanager.memory.jvm-metaspace.size: 512m" >> /opt/flink/conf/flink-conf.yaml;
RUN echo "taskmanager.memory.task.off-heap.size: 80mb" >> /opt/flink/conf/flink-conf.yaml;

WORKDIR /opt/flink
