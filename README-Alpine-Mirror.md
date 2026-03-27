# Alpine Mirror

The `Dockerfile` for this action uses a mirrored Alpine image hosted on GitHub Container Registry (GHCR) rather than Docker Hub directly. This avoids Docker Hub's unauthenticated pull limits which affect GitHub Actions runners.

Mirror location: `ghcr.io/giganticplayground/git-sync/alpine`

## When to update

Re-mirror whenever you need to upgrade the Alpine version in the `Dockerfile`. Check [Alpine Linux releases](https://alpinelinux.org/releases/) for available versions.

## How to push a new mirror

You will need a GitHub Personal Access Token (PAT) with `write:packages` scope.

**1. Authenticate with GHCR**

```bash
echo $GITHUB_TOKEN | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
```

**2. Mirror the multi-platform image to GHCR**

This pulls Alpine for all supported platforms and pushes them as a single multi-platform manifest. The `--annotation` flag links the package to this repository in GHCR:

```bash
docker buildx imagetools create \
  --tag ghcr.io/giganticplayground/git-sync/alpine:3.23 \
  --annotation "index:org.opencontainers.image.source=https://github.com/GiganticPlayground/git-sync" \
  alpine:3.23
```

> `imagetools create` copies the existing multi-platform manifest directly from Docker Hub without re-building — no local pull needed.

**3. Verify the manifest**

```bash
docker buildx imagetools inspect ghcr.io/giganticplayground/git-sync/alpine:3.23
```

You should see entries for `linux/amd64`, `linux/arm64`, `linux/arm/v6`, `linux/arm/v7`, and others.

**4. Set package visibility to public**

In GitHub, go to the `git-sync` repo > Packages > `alpine` > Package settings > Change visibility to **Public**. This is required for the GitHub Actions runner to pull it without credentials.

## Updating the Dockerfile

After pushing a new version, update the `FROM` line in `Dockerfile`:

```dockerfile
FROM ghcr.io/giganticplayground/git-sync/alpine:3.23
```
