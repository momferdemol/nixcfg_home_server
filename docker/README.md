# Docker host

Docker is a set of products that uses operating system-level virtualization to deliver software in packages called containers. Docker automates the deployment of applications within lightweight containers, enabling them to run consistently across different computing environments.

## Media share

In `/var/secrets/` directory add `smbcred` for media access.

```
username=XXXXXXXXX
password=XXXXXXXX
domain=WORKGROUP
```

In `/var/secrets/` directory add `dnscred` for caddy.

```
AWS_ACCESS_KEY_ID=XXXXXX
AWS_SECRET_ACCESS_KEY=XXXXXX
AWS_REGION=eu-west-1
AWS_HOSTED_ZONE=XXXXX
```

# Containers

## Navidrome

- [Navidrome](./containers/navidrome/)

# Commands

```sh
docker compose up -d
```

```sh
docker compose ps
```

```sh
docker logs [container]
```

```sh
docker compose down
```

```sh
docker container prune --filter "until=24h" --dry-run  # show stopped containers older than 24h
```
