#!/usr/bin/env bash
set -euo pipefail
python3 -m py_compile app/server.py
if command -v terraform >/dev/null; then
  terraform fmt -check -recursive infra
  for dir in infra/ec2 infra/ecs infra/eks; do
    terraform -chdir="$dir" init -backend=false -input=false
    terraform -chdir="$dir" validate
  done
fi
if command -v docker >/dev/null; then docker build -t cloud-ops-demo:local .; fi
