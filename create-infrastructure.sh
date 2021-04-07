#!/bin/sh

echo "Creating cloud resources..."

echo "-----------------------------------------------------"
echo "Using environment variables:"
echo "AZ_RESOURCE_GROUP=$AZ_RESOURCE_GROUP"
echo "AZ_SPRING_CLOUD_NAME=$AZ_SPRING_CLOUD_NAME"
echo "AZ_LOCATION=$AZ_LOCATION"

echo "-----------------------------------------------------"
echo "Creating resource group"

az group create \
    --name $AZ_RESOURCE_GROUP \
    -l $AZ_LOCATION \
    | jq

echo "-----------------------------------------------------"
echo "Creating Azure Spring Cloud cluster"

az spring-cloud create \
    -g "$AZ_RESOURCE_GROUP" \
    -n "$AZ_SPRING_CLOUD_NAME" \
    -l $AZ_LOCATION \
    --enable-java-agent \
    --sku standard \
    | jq

echo "-----------------------------------------------------"
echo "Creating Azure Spring Cloud application"

az spring-cloud app create \
    -n person-service \
    -g "$AZ_RESOURCE_GROUP" \
    -n "$AZ_SPRING_CLOUD_NAME" \
    --assign-endpoint true \
    | jq

echo "-----------------------------------------------------"
echo "Deploying Azure Spring Cloud application"

./mvnw package

az spring-cloud app deploy \
    -g "$AZ_RESOURCE_GROUP" \
    -n "$AZ_SPRING_CLOUD_NAME" \
    -n person-service \
    --jar-path target/demo-0.0.1-SNAPSHOT.jar \
    | jq
