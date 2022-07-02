#!/usr/bin/env bash

# Exit if any of the intermediate steps fail
set -e

# Extract "foo" and "baz" arguments from the input into
# FOO and BAZ shell variables.
# jq will ensure that the values are properly quoted
# and escaped for consumption by the shell.
eval "$(jq -r '@sh "HOST=\(.host) USER=\(.user) SSH_KEY_FILE=\(.ssh_key_file) GITLAB_PASSWORD_FILE=\(.gitlab_password_file)"')"

password=$(ssh -i $SSH_KEY_FILE $USER@$HOST "sudo grep -oP '(?<=Password: ).*' ${GITLAB_PASSWORD_FILE}")

# Safely produce a JSON object containing the result value.
# jq will ensure that the value is properly quoted
# and escaped to produce a valid JSON string.
#jq -n --arg foobaz "$FOOBAZ" '{"foobaz":$foobaz}'

jq -n --arg password "$password" '{"password":$password}'