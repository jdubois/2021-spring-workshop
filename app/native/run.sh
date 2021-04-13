#!/usr/bin/env bash
docker run -e "SPRING_CONFIG_IMPORT=configserver:http://host.docker.internal:8888" docker.io/library/bootiful:0.0.1-SNAPSHOT
