#!/usr/bin/env bash
# Prints Envoy's releases as labelled in the Buf registry, oldest first, without the leading "v", from the given minimum
# version (default: all). Skips a release whose protos are the same as the release before it: Buf labels point at
# content-addressed commits, so an unchanged release carries the previous one's commit.
# shortcut: reads one page of 250 labels (40 in Oct 2026); follow nextPageToken once Envoy has more.
set -euo pipefail
min="${1:-0.0.0}"
curl -sSf -X POST https://buf.build/buf.registry.module.v1.LabelService/ListLabels \
    -H 'Content-Type: application/json' \
    -d '{"pageSize":250,"resourceRef":{"name":{"owner":"envoyproxy","module":"envoy"}}}' \
  | jq -r '.labels[] | "\(.name) \(.commitId)"' | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+ ' | sed 's/^v//' | sort -V \
  | awk -v min="${min}" '
      function atLeast(a, b,  x, y, i) {
        split(a, x, "."); split(b, y, ".")
        for (i = 1; i <= 3; i++) if (x[i] + 0 != y[i] + 0) return x[i] + 0 > y[i] + 0
        return 1
      }
      atLeast($1, min) { if ($2 != last) print $1; last = $2 }'
