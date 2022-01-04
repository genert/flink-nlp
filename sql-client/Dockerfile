###############################################################################
# Build SQL Playground Image
###############################################################################

FROM flink:1.14.2-scala_2.12
ARG FLINK_VERSION=1.14.2
ARG SPACY_VERSION=3.2.0
ARG SCALA_BINARY_VERSION=2.12

# Create CLI lib folder
COPY bin/* /opt/sql-client/
RUN mkdir -p /opt/sql-client/lib

# Download connector libraries
RUN wget -P /opt/sql-client/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-json/${FLINK_VERSION}/flink-json-${FLINK_VERSION}.jar; \
    wget -P /opt/sql-client/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-csv/${FLINK_VERSION}/flink-csv-${FLINK_VERSION}.jar; \
    wget -P /opt/sql-client/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-sql-avro-confluent-registry/${FLINK_VERSION}/flink-sql-avro-confluent-registry-${FLINK_VERSION}.jar; \
    wget -P /opt/sql-client/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-sql-connector-kafka_${SCALA_BINARY_VERSION}/${FLINK_VERSION}/flink-sql-connector-kafka_${SCALA_BINARY_VERSION}-${FLINK_VERSION}.jar; \
    wget -P /opt/sql-client/lib/ https://repo1.maven.org/maven2/org/apache/kafka/kafka-clients/2.5.0/kafka-clients-2.5.0.jar
    
# Copy configuration
COPY conf/* /opt/flink/conf/

WORKDIR /opt/sql-client
ENV SQL_CLIENT_HOME /opt/sql-client

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
