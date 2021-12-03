FROM flink:1.13.3-scala_2.12-java11
ARG FLINK_VERSION=1.13.3
ARG SPACY_VERSION=3.2.0

# 1. Setup Conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py38_4.10.3-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean --all -y && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc
ENV PATH /opt/conda/bin:$PATH
SHELL ["/bin/bash", "--login", "-c"]

# 2. Install PyFlink
RUN pip install apache-flink==${FLINK_VERSION}

# 3. Install spaCy
RUN pip install -U spacy==${SPACY_VERSION}; \
    python -m spacy download en_core_web_md

# 4. Download connector libraries
RUN wget -P /opt/flink/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-json/${FLINK_VERSION}/flink-json-${FLINK_VERSION}.jar; \
    wget -P /opt/flink/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-csv/${FLINK_VERSION}/flink-csv-${FLINK_VERSION}.jar; \
    wget -P /opt/flink/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-sql-avro/${FLINK_VERSION}/flink-sql-avro-${FLINK_VERSION}.jar; \
    wget -P /opt/flink/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-connector-jdbc_2.12/${FLINK_VERSION}/flink-connector-jdbc_2.12-${FLINK_VERSION}.jar; \
    wget -O /opt/flink/lib/pulsar-flink-sql-connector_2.12-1.13.1.4.jar https://search.maven.org/remotecontent?filepath=io/streamnative/connectors/pulsar-flink-sql-connector_2.12/1.13.1.4/pulsar-flink-sql-connector_2.12-1.13.1.4.jar

# 5. Configure Flink
RUN echo "taskmanager.memory.jvm-metaspace.size: 512m" >> /opt/flink/conf/flink-conf.yaml;
RUN echo "taskmanager.memory.task.off-heap.size: 80mb" >> /opt/flink/conf/flink-conf.yaml;

WORKDIR /opt/flink