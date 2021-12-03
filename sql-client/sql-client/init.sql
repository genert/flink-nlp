-- Define available catalogs

CREATE CATALOG pulsar WITH (
   'type' = 'pulsar',
   'service-url' = 'pulsar://pulsar:6650',
   'admin-url' = 'http://pulsar:8080',
   'format' = 'json'
);

USE CATALOG pulsar;

-- Properties that change the fundamental execution behavior of a table program.

SET table.planner = blink; -- planner: either 'blink' (default) or 'old'
SET execution.runtime-mode = streaming; -- execution mode either 'batch' or 'streaming'
SET sql-client.execution.result-mode = table; -- available values: 'table', 'changelog' and 'tableau'
SET sql-client.execution.max-table-result.rows = 10000; -- optional: maximum number of maintained rows
SET parallelism.default = 1; -- optional: Flink's parallelism (1 by default)
SET pipeline.auto-watermark-interval = 200; --optional: interval for periodic watermarks
SET pipeline.max-parallelism = 128; -- optional: Flink's maximum parallelism
SET table.exec.state.ttl=1000; -- optional: table program's idle state time
SET restart-strategy = fixed-delay;
