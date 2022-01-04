import os
import logging
import sys

from pyflink.common import Row
from pyflink.datastream import StreamExecutionEnvironment
from pyflink.table import StreamTableEnvironment, EnvironmentSettings, DataTypes
from pyflink.table.udf import ScalarFunction, udf

import spacy
from spacytextblob.spacytextblob import SpacyTextBlob

class NLPSentiment(ScalarFunction):
    def open(self, function_context):
        self.nlp = spacy.load("en_core_web_md")
        self.nlp.add_pipe('spacytextblob')

    def eval(self, str):
        doc = self.nlp(str)
        return doc._.polarity    

class NLPNamedEntityRecognition(ScalarFunction):
    def open(self, function_context):
        self.nlp = spacy.load("en_core_web_md")

    def eval(self, str):
        doc = self.nlp(str)
        return [Row(text=ent.text, entity=ent.label_) for ent in doc.ents]

def main():
    # Create streaming environment
    env = StreamExecutionEnvironment.get_execution_environment()

    # Add kafka connector dependency
    kafka_jar = os.path.join(os.path.abspath(os.path.dirname(__file__)), 'flink-sql-connector-kafka_2.11-1.14.2.jar')
    env.add_jars("file://{}".format(kafka_jar))

    settings = EnvironmentSettings.new_instance()\
                      .in_streaming_mode()\
                      .use_blink_planner()\
                      .build()

    tbl_env = StreamTableEnvironment.create(stream_execution_environment=env,
                                            environment_settings=settings)
    
    #######################################################################
    # Define UDFs
    #######################################################################
    tbl_env.create_temporary_function("NLP_SENTIMENT", udf(NLPSentiment(), result_type=DataTypes.FLOAT()))
    tbl_env.create_temporary_function("NLP_NER", udf(NLPNamedEntityRecognition(), result_type=DataTypes.ARRAY(
        DataTypes.ROW([
            DataTypes.FIELD("text", DataTypes.STRING()),
            DataTypes.FIELD("entity", DataTypes.STRING()),
        ])
    )))

    #######################################################################
    # Create Kafka Source Table with DDL
    #######################################################################
    tbl_env.execute_sql("""
        CREATE TABLE tweets (
            id BIGINT,
            text VARCHAR,
            created_at BIGINT,
            coordinates ARRAY<DOUBLE>,
            proctime AS PROCTIME()
        ) WITH (
            'connector' = 'kafka',
            'topic' = 'tweets',
            'properties.bootstrap.servers' = 'localhost:9092',
            'properties.group.id' = 'tweets',
            'scan.startup.mode' = 'earliest-offset',
            'format' = 'json'
        )
    """)

    tbl_env.execute_sql("""
    CREATE TABLE print (
        id BIGINT,
        text VARCHAR,
        sentiment_polarity DOUBLE,
        entities ARRAY<ROW<text STRING, entity STRING>>
    ) WITH (
        'connector' = 'print'
    )
    """)

    tbl_env.execute_sql("""
    INSERT INTO print
    SELECT id, text, NLP_SENTIMENT(text), NLP_NER(text) FROM tweets
    """).wait()


    #####################################################################
    # Define Tumbling Window Aggregate Calculation of Revenue per Seller
    #
    # - for every 30 second non-overlapping window
    # - calculate the revenue per seller
    #####################################################################
    # windowed_rev = tbl_env.sql_query("""
    #     SELECT
    #         id,
    #         TUMBLE_START(proctime, INTERVAL '30' SECONDS) AS window_start,
    #         TUMBLE_END(proctime, INTERVAL '30' SECONDS) AS window_end
    #     FROM tweets
    #     GROUP BY
    #         id,
    #         TUMBLE(proctime, INTERVAL '30' SECONDS)
    # """)
    # print('\nProcess Sink Schema')
    # windowed_rev.print_schema()

    # tbl_env.execute('flink-nlp')

if __name__ == '__main__':
    logging.basicConfig(stream=sys.stdout, level=logging.INFO, format="%(message)s")

    main()

