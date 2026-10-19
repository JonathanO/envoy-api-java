# Envoy Java API

Java protobuf and gRPC classes for the [Envoy](https://www.envoyproxy.io/) xDS API, published as
`net.woaf.jono.envoy:envoy-api`.

## Versioning

Each release is built from one Envoy release and carries its version: `1.40.0` is Envoy 1.40.0's API. A rebuild of the
same Envoy release gets a suffix, e.g. `1.40.0-1`. Use the version matching the Envoy you run, or any later one: the v3
API only grows, and older Envoys ignore fields they don't know (see Envoy's
[API versioning policy](https://github.com/envoyproxy/envoy/blob/main/api/API_VERSIONING.md)).

The classes are generated with protoc 3.25, so they run on protobuf-java 3.25+ and 4.x.

## How it's built

Envoy publishes every release to the [Buf registry](https://buf.build/envoyproxy/envoy) together with its third-party
proto dependencies (xds, udpa, protoc-gen-validate, googleapis, cel, OpenTelemetry, Prometheus), pinned by Envoy's
`api/buf.lock`. The build exports one release from there and compiles it:

```
./gradlew build -PenvoyVersion=1.40.0
```

This needs the [`buf` CLI](https://buf.build/docs/cli/installation/) on your `PATH`.

`google/api/annotations.proto`, `google/api/http.proto` and `google/rpc/status.proto` are not bundled: they come from
`com.google.api.grpc:proto-google-common-protos`, which gRPC already depends on, so the classes aren't duplicated.

## Releasing

`.github/workflows/release.yml` runs daily. It publishes every Envoy release from 1.31.0 on that has no `v<version>`
tag in this repository yet, then tags it. Run it by hand to publish one version, or a rebuild with a build number.

It does nothing until the repository variable `PUBLISH` is `true`, and needs these secrets:
`SONATYPE_USER`, `SONATYPE_PASSWORD` (a Maven Central Portal user token), `OSS_SIGNING_KEY` and `OSS_SIGNING_PASSWORD`.
