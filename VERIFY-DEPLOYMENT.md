# Verify DIAS Deployment

Your GitHub Actions succeeded! Here's how to verify everything is working end-to-end.

---

## ✅ Step 1: Verify Docker Images in GHCR

Check that all 4 images were pushed to GitHub Container Registry:

### Via GitHub Web UI:
1. Go to: https://github.com/orgs/larstrustworks/packages
2. You should see 4 packages:
   - `dias-admin-ui` (from DiasAdminUi repo)
   - `dias-dal-api` (from DiasDalApi repo)
   - `dias-rest-api` (from DiasRestApi repo)
   - `dias-ui` (from dias-edu-hub repo)

### Via Command Line (on your Linux server):
```bash
# Login to GHCR
echo $GITHUB_PAT | docker login ghcr.io -u larstrustworks --password-stdin

# Pull images to verify they exist
docker pull ghcr.io/larstrustworks/dias-admin-ui:latest
docker pull ghcr.io/larstrustworks/dias-dal-api:latest
docker pull ghcr.io/larstrustworks/dias-rest-api:latest
docker pull ghcr.io/larstrustworks/dias-ui:latest
```

---

## ✅ Step 2: Check Deployment Workflow

The build workflows should have triggered the deployment workflow in `dias-stack-deployment`:

1. Go to: https://github.com/larstrustworks/dias-stack-deployment/actions
2. Look for recent "Deploy" workflow runs
3. Check if they ran on your **self-hosted runner** (should show the runner name, not "ubuntu-latest")
4. Verify the workflow succeeded

**Expected behavior:**
- Each time you push to `dev` branch in an app repo
- Build workflow runs → builds image → pushes to GHCR
- Build workflow triggers deployment workflow via `WORKFLOW_PAT`
- Deployment workflow runs on self-hosted runner on your Linux server
- Server pulls new image and restarts container

---

## ✅ Step 3: Verify on Linux Server

SSH into your Ubuntu server and check the running containers:

```bash
# SSH to server
ssh your-user@your-server-ip

# Check running containers
docker ps

# Expected output: 4 containers running
# - dias-dalapi (or similar name)
# - dias-restapi
# - dias-adminui
# - dias-eduhub

# Check container logs
docker logs <container-name>

# Check when images were pulled (should be recent)
docker images | grep ghcr.io/larstrustworks

# Check docker-compose status
cd ~/dias-stack/dias-stack-deployment  # or wherever your deployment is
docker compose ps
```

---

## ✅ Step 4: Test the APIs

### Test DalApi
```bash
# On server or from your PC (if ports are exposed)
curl http://localhost:8082/health
# or
curl http://your-server-ip:8082/health
```

### Test RestApi
```bash
curl http://localhost:8081/health
# or
curl http://your-server-ip:8081/health
```

### Test AdminUI
```bash
# Open in browser
http://your-server-ip:3001
```

### Test EduHub
```bash
# Open in browser
http://your-server-ip:3002
```

---

## ✅ Step 5: Test Full Deployment Flow

Make a small change and verify the entire pipeline works:

```powershell
# On your Windows PC
cd c:\Users\A246428\dias\DiasAdminUi

# Make a small change (e.g., add a comment to README)
echo "# Test deployment" >> README.md

# Commit and push
git add README.md
git commit -m "test: verify deployment pipeline"
git push origin dev
```

**Then watch:**
1. GitHub Actions in DiasAdminUi repo → Build workflow runs
2. GitHub Actions in dias-stack-deployment repo → Deploy workflow triggers
3. On Linux server → Container restarts with new image

**Verify on server:**
```bash
# Check logs for the restart
docker logs dias-adminui --tail 50

# Check image timestamp
docker images ghcr.io/larstrustworks/dias-admin-ui:latest
```

---

## 🔍 Troubleshooting

### Build workflow succeeded but deployment didn't trigger

**Check:**
- `WORKFLOW_PAT` secret exists in app repos
- PAT has `workflow` scope
- PAT hasn't expired
- Deployment workflow file exists in `dias-stack-deployment/.github/workflows/deploy.yml`

**Fix:**
```bash
# Check GitHub Actions logs for the trigger step
# Look for errors in the "Trigger the 'deploy.yml' workflow" step
```

### Deployment workflow triggered but failed

**Check:**
- Self-hosted runner is online and connected
- Runner has access to pull from GHCR
- `.env` file exists on server with correct values
- `docker-compose.yml` has correct image names

**Fix:**
```bash
# On server, check runner status
cd ~/actions-runner
./run.sh --check

# Check runner logs
journalctl -u actions.runner.* -f
```

### Containers won't start

**Check:**
```bash
# Check container logs
docker logs <container-name>

# Check docker-compose logs
cd ~/dias-stack/dias-stack-deployment
docker compose logs

# Check .env file
cat ~/dias-stack/.env
# Verify DB_HOST, DB_USER, DB_PASSWORD, etc.
```

**Common issues:**
- Database not accessible from server
- Missing environment variables in `.env`
- Port conflicts
- Image pull authentication failed

---

## 📊 Monitoring

### Check deployment history
```bash
# On server
docker images | grep ghcr.io/larstrustworks

# Shows all image versions with timestamps
# You should see :latest and :<short-sha> tags
```

### Check container health
```bash
# On server
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# All containers should show "Up" status
```

### Check logs continuously
```bash
# On server
docker compose logs -f

# Or for specific service
docker logs -f dias-restapi
```

---

## 🎯 Success Criteria

✅ All 4 Docker images visible in GHCR  
✅ Deployment workflow runs on self-hosted runner  
✅ All 4 containers running on Linux server  
✅ APIs respond to health checks  
✅ Web UIs accessible in browser  
✅ Making a code change triggers full pipeline  
✅ Container restarts with new image automatically  

---

## Next Steps

Once verified:
1. **Set up monitoring** - Add health checks, logging aggregation
2. **Configure domains** - Point DNS to your server, set up reverse proxy (nginx/traefik)
3. **Add SSL/TLS** - Use Let's Encrypt for HTTPS
4. **Database backups** - Automate MSSQL backups
5. **Staging environment** - Create separate stack for testing
6. **Production deployment** - Replicate setup for production server

---

## Quick Reference

**GitHub Actions:**
- App repos: https://github.com/larstrustworks/<repo-name>/actions
- Deployment: https://github.com/larstrustworks/dias-stack-deployment/actions

**GHCR Packages:**
- https://github.com/orgs/larstrustworks/packages

**Server Commands:**
```bash
# Status
docker ps
docker compose ps

# Logs
docker logs <container>
docker compose logs -f

# Restart
docker compose restart <service>
docker compose up -d

# Pull latest
docker compose pull
docker compose up -d
```
