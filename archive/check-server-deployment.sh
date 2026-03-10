#!/bin/bash
# Diagnostic script to check DIAS deployment on Linux server
# Upload this to your server and run: bash check-server-deployment.sh

echo "=========================================="
echo "DIAS Deployment Diagnostic"
echo "=========================================="
echo ""

# 1. Check if Docker is running
echo "1. Docker Status:"
if command -v docker &> /dev/null; then
    docker --version
    echo "✓ Docker is installed"
else
    echo "✗ Docker is NOT installed"
    exit 1
fi
echo ""

# 2. Check running containers
echo "2. Running Containers:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

# 3. Check all containers (including stopped)
echo "3. All Containers (including stopped):"
docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"
echo ""

# 4. Check Docker images
echo "4. DIAS Docker Images:"
docker images | grep -E "ghcr.io/larstrustworks|IMAGE"
echo ""

# 5. Check if deployment directory exists
echo "5. Deployment Directory:"
if [ -d ~/dias-stack ]; then
    echo "✓ ~/dias-stack exists"
    ls -la ~/dias-stack/
else
    echo "✗ ~/dias-stack does NOT exist"
fi
echo ""

# 6. Check if .env file exists
echo "6. Environment File:"
if [ -f ~/dias-stack/.env ]; then
    echo "✓ ~/dias-stack/.env exists"
    echo "Variables (values hidden):"
    grep -E "^[A-Z_]+" ~/dias-stack/.env | sed 's/=.*/=***/'
else
    echo "✗ ~/dias-stack/.env does NOT exist"
fi
echo ""

# 7. Check if docker-compose.yml exists
echo "7. Docker Compose File:"
if [ -f ~/dias-stack/dias-stack-deployment/docker-compose.yml ]; then
    echo "✓ docker-compose.yml exists"
else
    echo "✗ docker-compose.yml does NOT exist"
fi
echo ""

# 8. Check GitHub runner
echo "8. GitHub Runner Status:"
if [ -d ~/actions-runner ]; then
    echo "✓ ~/actions-runner exists"
    if systemctl is-active --quiet actions.runner.* 2>/dev/null; then
        echo "✓ Runner service is active"
        systemctl status actions.runner.* --no-pager | grep "Active:"
    else
        echo "⚠ Runner service not found or not active"
    fi
else
    echo "✗ ~/actions-runner does NOT exist"
fi
echo ""

# 9. Check container logs (last 10 lines each)
echo "9. Container Logs (last 10 lines):"
for container in dias-dal-api dias-rest-api dias-ui dias-admin-ui; do
    if docker ps -a --format '{{.Names}}' | grep -q "^${container}$"; then
        echo ""
        echo "--- $container ---"
        docker logs $container --tail 10 2>&1
    fi
done
echo ""

# 10. Check network connectivity
echo "10. Network Ports:"
echo "Listening ports:"
ss -tlnp 2>/dev/null | grep -E ":(8080|8081|9090|3000|3001)" || netstat -tlnp 2>/dev/null | grep -E ":(8080|8081|9090|3000|3001)" || echo "Could not check ports (need root)"
echo ""

# 11. Try to pull images
echo "11. Test Image Pull (checking GHCR access):"
echo "Attempting to pull dias-admin-ui:latest..."
docker pull ghcr.io/larstrustworks/dias-admin-ui:latest 2>&1 | head -5
echo ""

echo "=========================================="
echo "Diagnostic Complete"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. If containers are not running, check logs above"
echo "2. If images are missing, check GHCR authentication"
echo "3. If .env is missing, create it with required variables"
echo "4. If runner is not active, restart it"
