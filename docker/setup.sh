#!/bin/bash

curl -X POST \
  http://127.0.0.1:8080/api/metadata/taskdefs \
  -H 'Content-Type: application/json' \
  -H 'cache-control: no-cache' \
  -d '[
    {
      "name": "aie_cache_drilldown",
      "retryCount": 3,
      "timeoutSeconds": 1200,
      "timeoutPolicy": "TIME_OUT_WF",
      "retryLogic": "FIXED",
      "retryDelaySeconds": 600,
      "responseTimeoutSeconds": 1000
    },
    {
      "name": "virustotal_hostname_lookup",
      "retryCount": 3,
      "timeoutSeconds": 1200,
      "timeoutPolicy": "TIME_OUT_WF",
      "retryLogic": "FIXED",
      "retryDelaySeconds": 600,
      "responseTimeoutSeconds": 1000
    },
    {
      "name": "decision_change_case",
      "retryCount": 3,
      "timeoutSeconds": 1200,
      "timeoutPolicy": "TIME_OUT_WF",
      "retryLogic": "FIXED",
      "retryDelaySeconds": 600,
      "responseTimeoutSeconds": 1000
    },
    {
      "name": "change_case_status",
      "retryCount": 3,
      "timeoutSeconds": 1200,
      "timeoutPolicy": "TIME_OUT_WF",
      "retryLogic": "FIXED",
      "retryDelaySeconds": 600,
      "responseTimeoutSeconds": 1000
    },
    {
      "name": "add_tags_to_case",
      "inputParameters": {
        "token": "${workflow.input.token}"
      },
      "retryCount": 3,
      "timeoutSeconds": 1200,
      "timeoutPolicy": "TIME_OUT_WF",
      "retryLogic": "FIXED",
      "retryDelaySeconds": 600,
      "responseTimeoutSeconds": 1000
    }
]'


curl -X PUT \
  http://127.0.0.1:8080/api/metadata/workflow \
  -H 'Content-Type: application/json' \
  -H 'cache-control: no-cache' \
  -d '[{
    "name": "handle_suspicious_alarm",
    "description": "Evaluate the threat possibility of a suspicious alarm",
    "version": 1,
    "tasks": [
        {
            "name": "add_tags_to_case",
            "taskReferenceName": "attc",
            "inputParameters": {
                "http_request": {
                    "uri": "https://logrhythm:8501/lr-case-api/cases",
                    "method": "GET",
                    "headers": {
                        "Content-Type": "application/json",
                        "Authorization": "Bearer ${workflow.input.token}"
                    }
                }
            },
            "type": "HTTP"
        }
    ],
    "outputParameters": {
        "statues": "${get_es_1.output..status}",
        "workflowIds": "${get_es_1.output..workflowId}"
    },
    "schemaVersion": 2
}]'

