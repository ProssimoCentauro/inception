# User Documentation – Inception

## Services provided

The infrastructure offers the following services:

- **WordPress** blog (accessible via HTTPS).
- **MariaDB** database (internal, not exposed to the host).
- **Redis** cache – accelerates WordPress.
- **FTP server** – allows file uploads to the WordPress directory.
- **Static portfolio** – a simple website at `http://localhost:8080`.
- **Adminer** – web-based database manager at `http://localhost:8081`.
- **Redis Commander** – Redis GUI at `http://localhost:8082`.

## Starting and stopping the project

1. Open a terminal in the project root (where `Makefile` is located).
2. To start everything:  
   `make`
3. To stop all containers (without removing data):  
   `make down`
4. To stop and clean up (remove containers, networks, and prune system):  
   `make clean`
5. To completely reset (including volumes and host data):  
   `make fclean`  
   then `make` to restart.

## Accessing the website and administration panel

- Add the domain to your `/etc/hosts` (e.g., `127.0.0.1 rtodaro.42.fr`).
- Open your browser and go to:  
  **`https://rtodaro.42.fr`** (accept the self‑signed certificate).
- WordPress admin panel:  
  **`https://rtodaro.42.fr/wp-admin`**

## Credentials

All credentials are stored in the `.env` file **outside the Git repository**.  
If you are the administrator, you should have set them during the initial setup.  
Default example values (change them):

- WordPress admin: `RikyBoy` / `super_secret_word`
- WordPress normal user: `wp_subscriber` / `less_secret_word`
- Database root: `db_root_password`
- FTP user: `wpuser` / `crazy_word`

**Never commit the `.env` file to version control.**

## Checking that services are running correctly

Run `docker ps` – you should see eight containers all in `Up` state (or `healthy`).  
You can also check logs: `docker logs <container_name> --tail 20`.

**Basic health checks**:
- WordPress: `curl -k https://rtodaro.42.fr | grep "Hello world"`
- Redis: `docker exec redis redis-cli ping` → `PONG`
- FTP: `ftp localhost 21` (use the FTP credentials)
- Static site: `curl http://localhost:8080`
- Adminer: browse `http://localhost:8081`
- Redis Commander: browse `http://localhost:8082`

If any container is `Restarting`, inspect its logs.
