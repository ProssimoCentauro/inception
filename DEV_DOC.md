# Developer Documentation – Inception

## Setting up the environment from scratch

### Prerequisites

- A Linux distribution (Debian/Ubuntu recommended) or WSL2.
- Docker Engine (≥20.10) and Docker Compose (≥2.20) installed.
- `make`, `git`, and a text editor.

---

## Cloning and configuration

```bash
git clone <your_repo_url> inception
cd inception
```

Create a `.env` file in the root directory.

Example:

```env
DOMAIN_NAME=login.42.fr

MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
MYSQL_PASSWORD=db_password
MYSQL_ROOT_PASSWORD=db_root_password

WP_ADMIN_USER=wp_super_user
WP_ADMIN_PASSWORD=super_secret_word
WP_ADMIN_EMAIL=super_user@example.com

WP_USER=wp_subscriber
WP_USER_PASSWORD=less_secret_word
WP_USER_EMAIL=user@example.com

FTP_USER=wpuser
FTP_PASSWORD=crazy_word
```

Make sure the domain name matches the one you will add to `/etc/hosts`.

---

## Building and launching the project

Run:

```bash
make
```

This will:

- Build all Docker images (`docker compose build`)
- Create the required host directories:
  - `/home/$USER/data/wordpress`
  - `/home/$USER/data/mariadb`
- Start all containers in detached mode

The containers are defined in `srcs/docker-compose.yml` and use environment variables from `.env`.

---

## Useful commands for managing containers and volumes

| Command | Action |
|---|---|
| `make up` | Start containers (if already built) |
| `make down` | Stop containers, keep volumes |
| `make clean` | Stop + `docker system prune -af` |
| `make fclean` | Clean + remove named volumes + delete host data |
| `make re` | Full rebuild (`fclean + build + up`) |

---

## Manual Docker commands

List container statuses:

```bash
docker compose -f srcs/docker-compose.yml ps
```

View service logs:

```bash
docker compose -f srcs/docker-compose.yml logs <service>
```

Restart a single service:

```bash
docker compose -f srcs/docker-compose.yml restart <service>
```

Open a shell inside a container:

```bash
docker exec -it <container> bash
```

---

## Project data persistence

### WordPress files

Stored in the named volume `wordpress_files`, bound to:

```text
/home/$USER/data/wordpress
```

### MariaDB data

Stored in the named volume `mariadb_data`, bound to:

```text
/home/$USER/data/mariadb
```

These bind mounts are defined in the `volumes` section of `docker-compose.yml` using the local driver with device paths.

If you change the host user, update the device paths accordingly (or use the `USER` environment variable — the Makefile already uses `$(USER)`).

---

## Debugging tips

Check container logs first:

```bash
docker logs <name>
```

Check NGINX configuration:

```bash
docker exec nginx nginx -t
```

Test WordPress ↔ MariaDB connectivity:

```bash
docker exec wordpress mysql -h mariadb -u root -p$MYSQL_ROOT_PASSWORD -e "SELECT 1"
```

Fix volume permission issues:

```bash
chown $USER:$USER /home/$USER/data
```

If a container restarts endlessly, run it in the foreground:

```bash
docker compose -f srcs/docker-compose.yml up <service>
```

(remove `-d`)

---

## Additional notes

- All services automatically restart on crash using:

```yaml
restart: unless-stopped
```

- No hacky patches (`tail -f`, `sleep infinity`, etc.) are used.
- The NGINX container is the only public entrypoint on port `443`.
- TLS certificates are self-signed for development purposes. In production, replace them with proper CA-signed certificates.
