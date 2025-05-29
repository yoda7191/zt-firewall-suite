#!/bin/bash

ZT_CONTROLLER="http://localhost:9993"
ZT_TOKEN=$(cat ~/.zerotier-one-authtoken)

get_zt_networks() {
    curl -s -H "X-ZT1-Auth: $ZT_TOKEN" "$ZT_CONTROLLER/controller/network" | jq -r 'keys[]'
}

get_zt_ips() {
    local network_id=$1
    curl -s -H "X-ZT1-Auth: $ZT_TOKEN" "$ZT_CONTROLLER/controller/network/$network_id/member" |
        jq -r '.[].config.ipAssignments[]' 2>/dev/null
}