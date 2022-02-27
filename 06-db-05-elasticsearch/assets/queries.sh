#!/usr/bin/env bash
USERNAME=elastic
PASSWORD=7iKtG_85jBHYfpL9yd37
ES_URL="https://localhost:9200"
INDEX="ind-3"
REPLICAS=2
SHARDS=4

curl -k -u ${USERNAME}:${PASSWORD} -X PUT "${ES_URL}/${INDEX}?pretty" \
    -H 'Content-Type: application/json' -d'
    {
    "settings": {
        "index": {
        "number_of_shards": '${SHARDS}',  
        "number_of_replicas": '${REPLICAS}' 
        }
    }
    }
    '

curl -k -u ${USERNAME}:${PASSWORD} -X GET "${ES_URL}/_cat/indices?pretty"

curl -k -u ${USERNAME}:${PASSWORD} -X GET "${ES_URL}/_cluster/health"