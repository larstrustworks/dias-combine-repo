# DIAS Deployment Checklist

## ✅ Local Development Setup (Complete)

- [x] VPN MSSQL connection configured (10.200.241.41)
- [x] DalApi `appsettings.Development.json` updated
- [x] AdminUI `.env.local` created
- [x] EduHub `.env.local` created
- [x] Startup scripts created (`start-*.ps1`)
- [x] Local dev guide created

### Test Local Development

```powershell
# Connect VPN first!
cd c:\Users\A246428\dias
.\start-all.ps1
```

**Expected Results:**
- DalApi running on http://localhost:8082
- RestApi running on http://localhost:8081
- AdminUI running on http://localhost:3001
- EduHub running on http://localhost:5174

---

## 🔍 Linux Server Deployment Verification

Based on your `DEV_DEPLOYMENT.md`, verify these are in place:

### GitHub Repositories (larstrustworks)
- [ ] `dias-stack-deployment` - Central deployment repo
- [ ] `DiasRestApi` - REST API code + Dockerfile
- [ ] `DiasDalApi` - DAL API code + Dockerfile
- [ ] `DiasAdminUi` - Admin UI code + Dockerfile
- [ ] `dias-edu-hub` - EduHub code + Dockerfile

### GitHub Actions Workflows

Each app repo should have `.github/workflows/build-and-deploy.yml`:
- [ ] DiasRestApi has workflow
- [ ] DiasDalApi has workflow
- [ ] DiasAdminUi has workflow
- [ ] dias-edu-hub has workflow

Central deployment repo should have `.github/workflows/deploy.yml`:
- [ ] dias-stack-deployment has deploy workflow

### GitHub Secrets

Each app repo needs this secret:
- [ ] `WORKFLOW_PAT` - Personal Access Token to trigger deployment

### Linux Server Setup

SSH into your Ubuntu server and verify:

```bash
# Check Docker is installed
docker --version
docker compose version

# Check GitHub runner is installed and running
cd ~/actions-runner
./run.sh --check  # or check systemd service

# Check deployment directory exists
ls -la ~/dias-stack/
# Should contain: .env file and dias-stack-deployment clone

# Check .env file has required variables
cat ~/dias-stack/.env
# Should have: DB_HOST, DB_USER, DB_PASSWORD, JWT_SECRET_KEY, etc.
```

Checklist:
- [ ] Docker installed on server
- [ ] Docker Compose installed on server
- [ ] GitHub self-hosted runner installed
- [ ] Runner registered to `dias-stack-deployment` repo
- [ ] Runner running as systemd service
- [ ] `~/dias-stack/.env` file exists with secrets
- [ ] `~/dias-stack/dias-stack-deployment` repo cloned

### Docker Images

Check if images can be pulled from GHCR:

```bash
# Login to GHCR (use PAT as password)
echo $GITHUB_PAT | docker login ghcr.io -u larstrustworks --password-stdin

# Try pulling an image
docker pull ghcr.io/larstrustworks/dias-rest-api:latest
docker pull ghcr.io/larstrustworks/dias-dal-api:latest
docker pull ghcr.io/larstrustworks/dias-admin-ui:latest
docker pull ghcr.io/larstrustworks/dias-edu-hub:latest
```

Checklist:
- [ ] Can authenticate to GHCR
- [ ] Images exist in GHCR
- [ ] Can pull images successfully

---

## 🚀 Test Deployment Flow

### 1. Make a small change locally

```powershell
# Example: Update a comment in DalApi
cd c:\Users\A246428\dias\DiasDalApi
# Edit a file, add a comment
git add .
git commit -m "test: trigger deployment"
git push origin main  # or dev branch
```

### 2. Watch GitHub Actions

- Go to https://github.com/larstrustworks/DiasDalApi/actions
- Verify "Build & Deploy" workflow starts
- Check it builds Docker image
- Check it pushes to GHCR
- Check it triggers deployment workflow

### 3. Watch Deployment

- Go to https://github.com/larstrustworks/dias-stack-deployment/actions
- Verify "Deploy" workflow starts
- Check it runs on self-hosted runner
- Check it pulls new image
- Check it restarts container

### 4. Verify on Server

```bash
# SSH to server
ssh user@your-server

# Check containers are running
docker ps

# Check logs
docker logs dias-dalapi-container  # or whatever the container name is

# Test the API
curl http://localhost:8082/health  # or whatever endpoint exists
```

---

## 📋 Quick Reference

### Local Development Ports
- DalApi: 8082
- RestApi: 8081
- AdminUI: 3001
- EduHub: 5174

### Production (Linux Server) Ports
Check your `docker-compose.yml` in `dias-stack-deployment` repo

### Database
- **Dev (VPN)**: 10.200.241.41
- **Prod**: Check `.env` on Linux server

### Repositories
- GitHub Org: `larstrustworks`
- Container Registry: `ghcr.io/larstrustworks`

---

## 🔧 Common Issues

### Local: Can't connect to database
- Verify VPN is connected
- Test: `Test-NetConnection -ComputerName 10.200.241.41 -Port 1433`

### Deployment: Workflow doesn't trigger
- Check `WORKFLOW_PAT` secret exists in app repos
- Verify PAT has `workflow` scope
- Check PAT hasn't expired

### Server: Container won't start
- SSH to server
- Check logs: `docker logs <container-name>`
- Check `.env` file has all required variables
- Verify database is accessible from server

### Server: Can't pull images
- Verify GHCR authentication
- Check image names match in docker-compose.yml
- Verify images were pushed successfully

---

## Next Steps

1. **Test local development** - Run `start-all.ps1` and verify all services work
2. **Verify GitHub setup** - Check all repos have workflows and secrets
3. **Verify server setup** - SSH and check runner, Docker, .env
4. **Test deployment** - Push a small change and watch it deploy
5. **Monitor** - Check logs and verify everything works end-to-end
