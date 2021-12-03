# Flink NLP

## Introduction

In this playground, you will learn how to build and run an end-to-end PyFlink pipeline for data analytics, covering the following steps:

    Reading data from a Pulsa source;
    Creating data using a UDF;
    Performing a simple aggregation over the source data;

The environment is based on Docker Compose, so the only requirement is that you have [Docker](https://www.docker.com/) installed in your machine.

## Docker

To keep things simple, the demo uses a Docker Compose setup that makes it easier to bundle up all the services you need.
Getting the setup up and running

```bash
docker network create flink-nlp
docker compose build
docker compose up -d
```

Is everything really up and running?

```bash
docker compose ps
```

You should be able to access the Flink Web UI (http://localhost:8081).

## Pulsar

You’ll use the [Twitter Firehose built-in connector](https://pulsar.apache.org/docs/en/io-twitter-source) to consume tweets about `Palantir` into a Pulsar topic. To create the Twitter source, run:

```bash
docker compose exec pulsar ./bin/pulsar-admin source create \
  --name twitter \
  --source-type twitter \
  --destinationTopicName tweets \
  --source-config '{"consumerKey":<consumerKey>,"consumerSecret":<consumerSecret>,"token":<token>,"tokenSecret":<tokenSecret>, "terms":"Palantir"}'
```

> :information_source: This source requires a valid Twitter authentication token, which you can generate on the [Twitter Developer Portal](https://developer.twitter.com/en/docs/authentication/oauth-1-0a/obtaining-user-access-tokens).

After creating the source, you can check that data is flowing into the `tweets` topic:

```bash
docker compose exec pulsar ./bin/pulsar-client consume -n 0 -r 0 -s test tweets
```

At any point, you can also [stop](https://pulsar.apache.org/docs/en/io-use/#stop-a-connector) the connector:

```bash
docker compose exec pulsar ./bin/pulsar-admin sources stop --name twitter
```

## Analyzing the Twitter feed in real-time

Submitting the PyFlink job

```bash
docker compose exec jobmanager ./bin/flink run --python /opt/job-nlp/main.py --detached
```

## Flink SQL

Next, you can start the Flink SQL Client:

```bash
docker-compose exec sql-client ./sql-client.sh
```

and use a [Pulsar catalog](https://github.com/streamnative/pulsar-flink#catalog) to access the topic directly as a table in Flink. This will make some things a lot easier afterwards, too!

```sql
CREATE CATALOG pulsar WITH (
   'type' = 'pulsar',
   'service-url' = 'pulsar://pulsar:6650',
   'admin-url' = 'http://pulsar:8080',
   'format' = 'json'
);

USE CATALOG pulsar;

SHOW TABLES;
```
