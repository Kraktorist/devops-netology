#!/usr/bin/env bash

. functions.sh

ES_USERNAME=elastic
ES_URL="https://localhost:9200"
ES_REPO_NAME="netology_backup"
ES_REPO_PATH="/var/lib/elasticsearch/snapshots"


create_index "ind-1" 0 1
create_index "ind-2" 1 2
create_index "ind-3" 2 4

list_indices
get_cluster_health
