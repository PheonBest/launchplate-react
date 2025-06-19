#!/bin/bash

set -euo pipefail

terraform workspace select prod

REPORT_DIR="pre-commit-report"
mkdir -p "$REPORT_DIR"

# Hooks to run
HOOKS=(
  terraform-docs-go
  terraform_fmt
  terraform_tflint
  terraform_validate
  terraform_checkov
  terraform_trivy
  infracost_breakdown
  check-merge-conflict
  check-yaml
  detect-private-key
  end-of-file-fixer
  trailing-whitespace
)

# Hooks to capture logs for
CAPTURE_LOGS=(
  terraform_tflint
  terraform_checkov
  terraform_trivy
  infracost_breakdown
)

# Hooks configuration
export INFRACOST_CURRENCY=EUR
export INFRACOST_CURRENCY_FORMAT="EUR: 1.234,56€"

for hook in "${HOOKS[@]}"; do
  echo "Running hook: $hook"

  if [[ " ${CAPTURE_LOGS[*]} " == *" $hook "* ]]; then
    # Save output to log file, continue on error
    if ! pre-commit run "$hook" -a --color never --verbose | tee "$REPORT_DIR/${hook}.txt"; then
      echo "Warning: Hook $hook failed but continuing..."
    fi
  else
    # Run silently (no output saved), continue on error
    if ! pre-commit run "$hook" -a --color never >/dev/null 2>&1; then
      echo "Warning: Hook $hook failed but continuing..."
    fi
  fi
done

# Prettify all json files under pre-commit-report/
find pre-commit-report/ -type f -name '*.json' -print0 | while IFS= read -r -d '' file; do
  jq . "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
done

echo "✅ All hooks have been run. Logs for selected hooks are in $REPORT_DIR/"
