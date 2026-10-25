# Envoy Java API

Java protobuf and gRPC classes for the [Envoy](https://www.envoyproxy.io/) xDS API, published as
`net.woaf.jono.envoy:envoy-api`.

## Versioning

Each release is built from one Envoy release and carries its version: `1.40.0` is Envoy 1.40.0's API. A rebuild of the
same Envoy release gets a suffix, e.g. `1.40.0-1`. An Envoy release whose protos are the same as the release before
isn't published, e.g. there's no 1.36.1 because its API is 1.36.0's. So use the newest version that isn't newer than
the Envoy you run, or any later one: the v3 API only grows, and older Envoys ignore fields they don't know (see Envoy's
[API versioning policy](https://github.com/envoyproxy/envoy/blob/main/api/API_VERSIONING.md)).

The javadoc jar only links to [Envoy's API docs](https://www.envoyproxy.io/docs/envoy/latest/api-v3/api); the sources
jar has the generated code.

The classes are generated with protoc 3.25, so they run on protobuf-java 3.25+ and 4.x.

## How it's built

Envoy publishes every release to the [Buf registry](https://buf.build/envoyproxy/envoy) together with its third-party
proto dependencies (xds, udpa, protoc-gen-validate, googleapis, cel, OpenTelemetry, Prometheus), pinned by Envoy's
`api/buf.lock`. The build exports one release from there and compiles it:

```
./gradlew build -PenvoyVersion=1.40.0
```

There's no default release. CI builds the latest one, from `.github/scripts/envoy-releases.sh`. This needs the
[`buf` CLI](https://buf.build/docs/cli/installation/) on your `PATH`.

Envoy and its proto dependencies are all Apache 2.0, like this project. `NOTICE` carries the notices of those that
have one (Envoy, Prometheus client_model), and goes into every jar with `LICENSE`. Check it when Envoy adds a
dependency to `api/buf.yaml`.

`google/api/annotations.proto`, `google/api/http.proto` and `google/rpc/status.proto` are not bundled: they come from
`com.google.api.grpc:proto-google-common-protos`, which gRPC already depends on, so the classes aren't duplicated.

## Releasing

`.github/workflows/release.yml` runs daily. It publishes every Envoy release from 1.36.0 (the oldest upstream still
supports) that has no `v<version>` tag in this repository yet, then tags it. It skips releases whose protos are the
same as the release before: Envoy's Buf labels point at content-addressed commits, so those share a commit. Run it by hand to publish one version, or a rebuild with a build number.

It does nothing until the repository variable `PUBLISH` is `true`, and needs these secrets:
`SONATYPE_USER`, `SONATYPE_PASSWORD` (a Maven Central Portal user token), `OSS_SIGNING_KEY` and `OSS_SIGNING_PASSWORD`.
