#!/usr/bin/env bash
docker run \
  -e "spring.data.mongodb.uri=mongodb://host.docker.internal/test" \
  -e "spring.config.import=configserver:http://host.docker.internal:8888" \
  -e "eureka.client.serviceUrl.defaultZone=http://host.docker.internal:8761/eureka/" \
  docker.io/library/bootiful:0.0.1-SNAPSHOT
