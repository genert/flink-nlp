FROM flink:1.13.1-scala_2.11-java11
ARG FLINK_VERSION=1.13.1

# Copy sql-client script
COPY sql-client/ /opt/sql-client
RUN mkdir -p /opt/sql-client/lib

# Download connector libraries
RUN wget -P /opt/sql-client/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-json/${FLINK_VERSION}/flink-json-${FLINK_VERSION}.jar; \
	wget -P /opt/sql-client/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-sql-avro/${FLINK_VERSION}/flink-sql-avro-${FLINK_VERSION}jar; \
    wget -P /opt/sql-client/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-connector-jdbc_2.11/${FLINK_VERSION}/flink-connector-jdbc_2.11-${FLINK_VERSION}.jar; \
    wget -P /opt/sql-client/lib/ http://dev-maven.xlink.cn:8333/nexus/content/groups/public/io/streamnative/connectors/pulsar-flink-sql-connector_2.11/${FLINK_VERSION}.4/pulsar-flink-sql-connector_2.11-${FLINK_VERSION}.4.jar;

# Copy configuration
COPY conf/* /opt/flink/conf/

WORKDIR /opt/sql-client
ENV SQL_CLIENT_HOME /opt/sql-client

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]