#!/usr/bin/env bash
# Prints Envoy's releases as labelled in the Buf registry, oldest first, without the leading "v".
# shortcut: reads one page of 250 labels (40 in Oct 2026); follow nextPageToken once Envoy has more.
set -euo pipefail
curl -sSf -X POST https://buf.build/buf.registry.module.v1.LabelService/ListLabels \
    -H 'Content-Type: application/json' \
    -d '{"pageSize":250,"resourceRef":{"name":{"owner":"envoyproxy","module":"envoy"}}}' \
  | jq -r '.labels[].name' | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | sed 's/^v//' | sort -V
