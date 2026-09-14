#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
dir="${root}/env/weu-lab"

echo "Destroy-Pfad: ${dir}"
echo "Firewall Standard läuft, bis dieses Destroy durch ist."
echo

if [[ ! -d "${dir}" ]]; then
  echo "env/weu-lab fehlt." >&2
  exit 1
fi

cd "${dir}"

if [[ ! -d .terraform ]]; then
  echo "Kein .terraform — zuerst terraform init, oder es wurde noch nichts deployed."
  exit 0
fi

terraform destroy "$@"
