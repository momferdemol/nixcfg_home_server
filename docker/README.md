# Docker host

Docker is a set of products that uses operating system-level virtualization to deliver software in packages called containers. Docker automates the deployment of applications within lightweight containers, enabling them to run consistently across different computing environments.

# Containers

## Navidrome

- [Navidrome](./containers/navidrome/)

> Create the `smbcred` in the `/var/secrets/` directory to establish NAS access.

```
username=<name>
password=<secret>
domain=WORKGROUP
```

# Commands

```sh
docker compose up -d
```

```sh
docker compose ps
```

```sh
docker compose down
```
