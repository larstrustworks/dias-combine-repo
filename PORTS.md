# DIAS Local Development Ports

## Configured Ports (when using start scripts)

The start scripts (`start-*.ps1`) override the default ports to ensure consistency:

| Service   | Port | Override Method | Default (launchSettings.json) |
|-----------|------|-----------------|-------------------------------|
| DalApi    | 8082 | ASPNETCORE_URLS | 5146                          |
| RestApi   | 8081 | ASPNETCORE_URLS | 5085                          |
| AdminUI   | 3001 | .env.local      | 3001                          |
| EduHub    | 5174 | .env.local      | 5174                          |

## Important Notes

1. **Always use the start scripts** (`start-all.ps1` or individual `start-*.ps1`) to ensure correct ports
2. **Don't run `dotnet run` directly** - it will use the default ports from launchSettings.json
3. **Port overrides** are set via `ASPNETCORE_URLS` environment variable + `--no-launch-profile` flag
4. **Frontend services** (AdminUI, EduHub) use ports defined in their `.env.local` files

### Why `--no-launch-profile`?

By default, `dotnet run` prioritizes launchSettings.json over environment variables. The `--no-launch-profile` flag forces it to ignore launchSettings.json and use our environment variables instead.

## Service Dependencies

```
DalApi (8082)
    ↓
RestApi (8081) ← connects to DalApi
    ↓
AdminUI (3001) ← connects to RestApi
EduHub (5174)  ← connects to RestApi
```

## Why Port Overrides?

The launchSettings.json files contain auto-generated ports (5146, 5085) that may conflict or be inconsistent. The start scripts enforce a consistent port scheme:
- **8082/8081**: Backend APIs (easy to remember: 82 for Dal, 81 for Rest)
- **3001**: Admin UI
- **5174**: EduHub (Vite default)

## Troubleshooting

If a service starts on the wrong port:
1. Check that you're using the start script, not running `dotnet run` directly
2. Verify the environment variable is set (scripts now show this)
3. Check for port conflicts with `Get-NetTCPConnection -LocalPort <port>`
