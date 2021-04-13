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
echo "Creating CosmosDB cluster"
export DATABASE_ID=$(az cosmosdb create \
    -n "cosmos-$AZ_SPRING_CLOUD_NAME" \
    -g "$AZ_RESOURCE_GROUP" \
    --kind MongoDB \
    | jq -r '.id')

echo "-----------------------------------------------------"
echo "Creating CosmosDB database"
az cosmosdb mongodb database create \
    -a "cosmos-$AZ_SPRING_CLOUD_NAME" \
    -g "$AZ_RESOURCE_GROUP" \
    -n "db-$AZ_SPRING_CLOUD_NAME" \
    | jq

echo "-----------------------------------------------------"
echo "Creating CosmosDB collection"
az cosmosdb mongodb collection create \
    -a "cosmos-$AZ_SPRING_CLOUD_NAME" \
    -g "$AZ_RESOURCE_GROUP" \
    -d "db-$AZ_SPRING_CLOUD_NAME" \
    -n "Person" \
    --shard 'id' \
    --throughput 400 \
    | jq

echo "-----------------------------------------------------"
echo "Creating Azure Spring Cloud cluster"

az spring-cloud create \
    -g "$AZ_RESOURCE_GROUP" \
    -n "$AZ_SPRING_CLOUD_NAME" \
    -l "$AZ_LOCATION" \
    --enable-java-agent \
    --sku standard \
    | jq

echo "-----------------------------------------------------"
echo "Configure config server"
az spring-cloud config-server git repo add \
    -g "$AZ_RESOURCE_GROUP" \
    -n "$AZ_SPRING_CLOUD_NAME" \
    --repo-name "spring-cloud-sample-public-config" \
    --uri https://github.com/Azure-Samples/spring-cloud-sample-public-config.git \
    | jq

echo "-----------------------------------------------------"
echo "Creating Azure Spring Cloud application"

az spring-cloud app create \
    -g "$AZ_RESOURCE_GROUP" \
    -s "$AZ_SPRING_CLOUD_NAME" \
    -n person-service \
    --runtime-version Java_11 \
    --assign-endpoint true \
    | jq

echo "-----------------------------------------------------"
echo "Bind CosmosDB to the Spring Cloud application"

az spring-cloud app binding cosmos add \
    -g "$AZ_RESOURCE_GROUP" \
    -s "$AZ_SPRING_CLOUD_NAME" \
    -n person-database \
    --app person-service \
    --resource-id "$DATABASE_ID" \
    --database-name "cosmos-$AZ_SPRING_CLOUD_NAME" \
    --api-type mongo \
    | jq


