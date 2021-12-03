#!/bin/bash

${FLINK_HOME}/bin/sql-client.sh embedded \
    --init ${SQL_CLIENT_HOME}/init.sql \
    --library ${SQL_CLIENT_HOME}/lib