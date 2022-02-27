#/usr/bin/env bash


function get_cluster_health {
    echo ""
    echo "=======Getting Cluster Health======="
    curl -k -u ${ES_USERNAME}:${ES_PASSWORD} -X GET "${ES_URL}/_cluster/health?pretty"
}

function create_repository {
    echo ""
    echo "=========Create Repository=========="
    curl -k -u ${ES_USERNAME}:${ES_PASSWORD} -X PUT "${ES_URL}/_snapshot/$1?pretty" \
        -H 'Content-Type: application/json' -d'
        {
        "type": "fs",
        "settings": {
            "location": "'$2'"
        }
        }
        '
}

function create_index {
    echo ""
    echo "===========Create Index============="
    curl -k -u ${ES_USERNAME}:${ES_PASSWORD} -X PUT "${ES_URL}/$1?pretty" \
        -H 'Content-Type: application/json' -d'
        {
        "settings": {
            "index": {
            "number_of_shards": '$3',  
            "number_of_replicas": '$2' 
            }
        }
        }
        '
}

function list_indices {
    echo ""
    echo "=========List Indices==============="
    curl -k -u ${ES_USERNAME}:${ES_PASSWORD} -X GET "${ES_URL}/_cat/indices?v"
}

function delete_index {
    echo ""
    echo "===========Delete Index============="
    curl -k -u ${ES_USERNAME}:${ES_PASSWORD} -X DELETE "${ES_URL}/$1?pretty"
}

function create_snapshot {
    echo ""
    echo "=========Create Snapshot============="
    curl -k -u ${ES_USERNAME}:${ES_PASSWORD} -X PUT "${ES_URL}/_snapshot/$1/$2?wait_for_completion=true&pretty"
}

function restore_snapshot {
    echo ""
    echo "=========Restore Snapshot============"
    echo 'curl -k -u ${ES_USERNAME}:${ES_PASSWORD} -X POST "'${ES_URL}'/_snapshot/'$1'/'$2'/_restore?wait_for_completion=true&pretty"'
    curl -k -u ${ES_USERNAME}:${ES_PASSWORD} -X POST "${ES_URL}/_snapshot/$1/$2/_restore?wait_for_completion=true&pretty"
}

(( ${#BASH_SOURCE[@]} == 1 )) && main "$@"