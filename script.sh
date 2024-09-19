#!/bin/bash -e

HOST='localhost:8083'
SQL_FILE="tables.sql"

function apiCall() {
  set -e

  local METHOD=$1
  local ENDPOINT=$2
  local REQUEST_BODY=$3

  local RESPONSE
  if [[ -n "$REQUEST_BODY" ]]; then
    RESPONSE=$(curl -s -L -w "\n%{http_code}" \
      -X "$METHOD" "http://${HOST}${ENDPOINT}" \
      -H "Accept: application/json" \
      -H "Content-Type: application/json" \
      -d "$REQUEST_BODY"
    )
  else
    RESPONSE=$(curl -s -L -w "\n%{http_code}" \
      -X "$METHOD" "http://${HOST}${ENDPOINT}" \
      -H "Accept: application/json"
    )
  fi

  local HTTP_STATUS
  HTTP_STATUS=$(echo "$RESPONSE" | tail -n 1)

  if [ "$HTTP_STATUS" == "200" ]; then
    local RESPONSE_BODY
    RESPONSE_BODY=$(echo "$RESPONSE" | sed \$d)
    echo "$RESPONSE_BODY"
  else
    local RESPONSE_BODY
    RESPONSE_BODY=$(echo "$RESPONSE" | sed \$d)
    echo "ERROR: Call $METHOD $ENDPOINT failed. HTTP status: $HTTP_STATUS, Response: $RESPONSE_BODY"
    exit 1
  fi
}

SESSIONHANDLE=$(apiCall "POST" "/sessions" '{"properties": {"execution.runtime-mode": "batch"}}' | jq -r '.sessionHandle' )
if [[ -z "$SESSIONHANDLE" ]]; then
  echo "ERROR: Failed to establish session."
  exit 1
fi
echo "Session $SESSIONHANDLE established."

SQL_CONTENT=$(<"$SQL_FILE")
IFS=';'

echo ""
for statement in $SQL_CONTENT; do

  if [[ -n "$statement" ]]; then
    SQL_STATEMENT_ONE_LINE_WITHOUT_COMMENTS="$(echo $statement | sed 's/--.*//' | tr '\n' ' ' | tr -s ' ');"

    echo -e "Processing SQL statement:\n$SQL_STATEMENT_ONE_LINE_WITHOUT_COMMENTS"

    OPERATIONHANDLE=$(apiCall "POST" "/sessions/$SESSIONHANDLE/statements" "{\"statement\": \"$SQL_STATEMENT_ONE_LINE_WITHOUT_COMMENTS\"}" | jq -r '.operationHandle')

    while true; do
      STATUS=$(apiCall "GET" "/sessions/$SESSIONHANDLE/operations/$OPERATIONHANDLE/status" | jq -r '.status')
      echo "Status: $STATUS"

      case $STATUS in
        "RUNNING")
          sleep 2
          ;;
        "FINISHED")
          break
          ;;
        *)
          echo "ERROR: Unexpected status: $STATUS"
          exit 1
          ;;
      esac
    done

    echo "--------------------------"
  fi
done

unset IFS

STATUS=$(apiCall "DELETE" "/sessions/$SESSIONHANDLE" | jq -r '.status')
case $STATUS in
  "CLOSED")
    echo -e "\nSession $SESSIONHANDLE closed."
    ;;
  *)
    echo "ERROR: Unexpected status: $STATUS"
    exit 1
    ;;
esac
