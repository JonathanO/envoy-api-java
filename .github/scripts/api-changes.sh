#!/usr/bin/env bash
# Prints the Envoy releases from the given version on whose API differs from the release before, oldest first.
# Compares descriptors without source info, so changes to comments don't count: they don't change the generated
# classes. Buf stamps its module commit into each descriptor, which changes even when the protos don't, so that's
# dropped. Needs the buf CLI.
set -euo pipefail
min="$1"
last=""
for v in $("$(dirname "$0")/envoy-releases.sh"); do
  if [ "$(printf '%s\n%s\n' "${min}" "${v}" | sort -V | head -1)" != "${min}" ]; then
    continue
  fi
  api=$(buf build "buf.build/envoyproxy/envoy:v${v}" --exclude-source-info -o -#format=json \
    | jq -cS '.file | map(del(.bufExtension)) | sort_by(.name)' | sha256sum)
  if [ "${api}" != "${last}" ]; then
    echo "${v}"
  fi
  last="${api}"
done
