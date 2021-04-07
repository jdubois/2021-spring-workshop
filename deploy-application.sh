#!/bin/sh

echo "Deploying application..."

echo "-----------------------------------------------------"
echo "Using environment variables:"
echo "AZ_RESOURCE_GROUP=$AZ_RESOURCE_GROUP"
echo "AZ_SPRING_CLOUD_NAME=$AZ_SPRING_CLOUD_NAME"
echo "AZ_LOCATION=$AZ_LOCATION"

echo "-----------------------------------------------------"
echo "Deploying Azure Spring Cloud application"

./mvnw package

az spring-cloud app deploy \
    -g "$AZ_RESOURCE_GROUP" \
    -s "$AZ_SPRING_CLOUD_NAME" \
    -n person-service \
    --jar-path target/demo-0.0.1-SNAPSHOT.jar \
    | jq
