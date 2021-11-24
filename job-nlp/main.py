from pyflink.table import EnvironmentSettings, StreamTableEnvironment, DataTypes
from pyflink.table.udf import udf
from pyflink.datastream import StreamExecutionEnvironment

ddl_pulsar_source = """
CREATE TABLE tweeets (
  publishTime TIMESTAMP(3) METADATA,
  WATERMARK FOR publishTime AS publishTime - INTERVAL '5' SECOND
) WITH (
  'connector' = 'pulsar',
  'topic' = 'persistent://public/default/tweets',
  'key.format' = 'raw',
  'key.fields' = 'key',
  'value.format' = 'avro',
  'service-url' = 'pulsar://localhost:6650',
  'admin-url' = 'http://localhost:8080',
  'scan.startup.mode' = 'earliest' 
)
"""

if __name__ == '__main__':
  env = StreamExecutionEnvironment.get_execution_environment()
  env.set_parallelism(1)
  t_env = StreamTableEnvironment.create(env)

  config = t_env.get_config().get_configuration()
  config.set_string("taskmanager.memory.task.off-heap.size", "80mb") #512mb