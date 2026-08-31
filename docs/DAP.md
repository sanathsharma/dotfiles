# Install and setup js-debug-adapter

See https://github.com/microsoft/vscode-js-debug/releases for latest versions
```sh
mkdir ~/dap-adapters
cd ~/dap-adapters
wget https://github.com/microsoft/vscode-js-debug/releases/download/v1.105.0/js-debug-dap-v1.105.0.tar.gz
tar -zxvf js-debug-dap-v1.105.0.tar.gz
```

# Conneting to a debug session for a process running in a docker container

## Debugging with `--inspect` in Docker

If the debugger attaches but breakpoints aren't hit, it's usually a **path mapping mismatch** between the host and container filesystems.

### Setup Checklist

1. **Bind inspector to `0.0.0.0`** (not `127.0.0.1`):
   ```
      node --watch --inspect=0.0.0.0:9229 index.js
   ```

2. **Expose the debug port** in `docker-compose.yml`:
```yaml
    ports:
        - "9229:9229"
```

3. **Map paths** in your debugger config (`launch.json` for VS Code):
    ```json
        {
            "type": "node",
            "request": "attach",
            "port": 9229,
            "localRoot": "${workspaceFolder}",
            "remoteRoot": "/app"
        }
    ```
> Set `remoteRoot` to the `WORKDIR` in your Dockerfile.

4. **Source maps** — if using TypeScript/Babel, ensure `"sourceMap": true` is set in `tsconfig.json`.

5. **`--watch` restarts** — the inspector session resets on each file change. Add `"restart": true` to `launch.json` to auto-reattach.`
