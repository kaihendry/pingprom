#!/bin/bash
# https://community.grafana.com/t/change-home-dashboard/7441/13?u=hendry

source ./.env

echo $GF_SECURITY_ADMIN_PASSWORD

dashboard_uid=bbe

id=$(curl -s -H 'Accept: application/json' -X GET --user "admin:$GF_SECURITY_ADMIN_PASSWORD" "http://localhost:3000/api/dashboards/uid/$dashboard_uid" | grep -Po '"dashboard":.*?"id":\K\d+')
curl -q -H 'Accept: application/json' -H 'Content-type: application/json' -X PUT --data "{ \"homeDashboardId\": $id }" --user "admin:$GF_SECURITY_ADMIN_PASSWORD" 'http://localhost:3000/api/org/preferences'
wait
