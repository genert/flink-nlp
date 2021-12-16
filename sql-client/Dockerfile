FROM flink:1.14.2-scala_2.12-java11
ARG FLINK_VERSION=1.13.3

# Download connector libraries
RUN mkdir -p /opt/sql-client/lib
RUN wget -P /opt/sql-client/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-json/${FLINK_VERSION}/flink-json-${FLINK_VERSION}.jar; \
    wget -P /opt/sql-client/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-csv/${FLINK_VERSION}/flink -csv-${FLINK_VERSION}.jar; \
    wget -P /opt/sql-client/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-sql-avro/${FLINK_VERSION}/flink-sql-avro-${FLINK_VERSION}.jar; \
    wget -P /opt/sql-client/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-connector-jdbc_2.12/${FLINK_VERSION}/flink-connector-jdbc_2.12-${FLINK_VERSION}.jar; \
    wget -O /opt/sql-client/lib/pulsar-flink-sql-connector_2.12-1.13.1.4.jar https://search.maven.org/remotecontent?filepath=io/streamnative/connectors/pulsar-flink-sql-connector_2.12/1.13.1.4/pulsar-flink-sql-connector_2.12-1.13.1.4.jar

# Copy configuration
COPY conf/* /opt/flink/conf/

WORKDIR /opt/sql-client
ENV SQL_CLIENT_HOME /opt/sql-client

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
