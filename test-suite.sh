#!/bin/bash

PASSED=0
FAILED=0

run_test() {
    echo "🧪 $1"
    eval "$2"
    if [ $? -eq 0 ]; then
        echo "✅ Passed"
        ((PASSED++))
    else
        echo "❌ Failed"
        ((FAILED++))
    fi
}

# Test 1: Validate nftables rule
run_test "Validate zerotier-swarm.nft" "nft -c -f modules/firewall/rules/zerotier-swarm.nft"

# Test 2: Check if fwctl exists
run_test "Check fwctl is executable" "[ -x modules/firewall/bin/fwctl ]"

# Test 3: Check suitectl commands
run_test "suitectl list-rules" "sudo modules/cli/suitectl firewall list-rules"

# Test 4: VNC script exists
run_test "Check VNC script" "[ -x modules/vnc/vncserver.sh ]"

# Test 5: Docker Swarm init script works
if command -v docker > /dev/null; then
    run_test "Docker Swarm Init" "sudo modules/docker-swarm/swarm-init.sh"
else
    echo "⚠️ Docker not found — skipping Docker tests"
fi

echo ""
echo "✅ $PASSED tests passed"
echo "❌ $FAILED tests failed"