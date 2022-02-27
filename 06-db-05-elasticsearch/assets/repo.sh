#!/usr/bin/env bash

. functions.sh

ES_USERNAME=elastic
ES_URL="https://localhost:9200"
ES_REPO_NAME="netology_backup"
ES_REPO_PATH="/var/lib/elasticsearch/snapshots"

create_repository $ES_REPO_NAME $ES_REPO_PATH
create_index "test" 0 1
list_indices
create_snapshot $ES_REPO_NAME "snapshot1"
# find  /var/lib/elasticsearch/snapshots  | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"
delete_index "test"
list_indices
create_index "test-2" 0 1
restore_snapshot $ES_REPO_NAME "snapshot1"
list_indices

