-- Define available catalogs

CREATE CATALOG pulsar WITH (
   'type' = 'pulsar',
   'service-url' = 'pulsar://pulsar:6650',
   'admin-url' = 'http://pulsar:8080',
   'format' = 'json'
);

USE CATALOG pulsar;

-- Properties that change the fundamental execution behavior of a table program.

SET 'execution.runtime-mode' = 'streaming';
SET 'sql-client.execution.result-mode' = 'table';
SET 'sql-client.execution.max-table-result.rows' = '10000';
SET 'restart-strategy' = 'fixed-delay';
SET 'table.local-time-zone' = 'UTC';
