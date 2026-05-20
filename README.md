*This project has been created as part of the 42 curriculum by rtodaro*

## Description

**Inception** is a system administration exercise that aims to build a small Docker‑based infrastructure.  
The project runs entirely inside a virtual machine and uses **Docker Compose** to orchestrate several services:

- **NGINX** (with TLSv1.2/TLSv1.3 only) – the only entry point on port 443.
- **WordPress + php‑fpm** – the CMS, served through NGINX.
- **MariaDB** – database for WordPress.
- **Two named volumes** – one for the WordPress database, one for the website files.
- **A custom Docker network** – connects all containers without using `host` network or `--link`.

All images are built from Debian `bookworm‑slim` (penultimate stable version).  
No `latest` tags are used, no passwords are hardcoded in Dockerfiles (environment variables + `.env` file).  
The containers restart automatically on crash and no hacky patches (`tail -f`, infinite loops) are employed.

The project also includes **bonus services**:
- Redis cache for WordPress
- FTP server (vsftpd) pointing to the WordPress volume
- Static portfolio website (HTML/CSS/JS)
- Adminer (lightweight database management)
- Redis Commander (graphical interface for Redis)

## Instructions

### Prerequisites
- Docker Engine (≥20.10) and Docker Compose (≥2.20)
- A Linux environment (the project is designed for Debian/Ubuntu, also works on WSL2 with mirrored networking)
- `make` utility

### Setup and execution
1. Clone the repository and enter the project root.
2. Create a `.env` file (use the provided template) with your own credentials and domain name.
3. Add your domain to `/etc/hosts` (e.g., `127.0.0.1 rtodaro.42.fr`).
4. Run `make` – this builds all images, creates the necessary host directories, and starts the containers.
5. Access the WordPress site at `https://rtodaro.42.fr` (accept the self‑signed certificate).
6. Use `make down` to stop all containers, `make clean` to prune the system, `make fclean` to also remove volumes and host data, and `make re` to fully rebuild.

### Persistent data
- WordPress files: `/home/rtodaro/data/wordpress`
- MariaDB data: `/home/rtodaro/data/mariadb`

## Resources

- [Docker documentation](https://docs.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [NGINX official docs](https://nginx.org/en/docs/)
- [WordPress Developer Resources](https://developer.wordpress.org/)
- [MariaDB knowledge base](https://mariadb.com/kb/en/)
- [vsftpd configuration](https://security.appspot.com/vsftpd.html)
- [Redis documentation](https://redis.io/documentation)

### How AI was used
- Understanding Docker best practices (PID 1, avoiding hacky patches).
- Debugging common errors (mount permissions, network connection, PHP‑FPM configuration).
- Generating the static portfolio HTML/CSS.
- Writing this documentation (with human review and adjustments).

## Comparison (mandatory section)

| Concept | Virtual Machines | Docker |
|---------|----------------|--------|
| **Virtual Machines vs Docker** | VMs emulate entire hardware, run a full OS, are slower, have higher overhead. | Containers share the host kernel, are lightweight, start in seconds. |

| **Docker Secrets vs Environment Variables** | Secrets are encrypted and mounted as temporary files, not exposed in inspect logs. | Environment variables are plain text, can be seen via `docker inspect` or logs, less secure. |

| **Docker Network vs Host Network** | `host` network gives the container the host’s network stack, no isolation. | Custom bridge networks provide isolation, DNS resolution between containers. |

| **Docker Volumes vs Bind Mounts** | Volumes are managed by Docker, can be named, work on all OS, better performance. | Bind mounts depend on host path, less portable, but allow direct host access. |

This project uses **named volumes** (for portability and persistence) bound to a specific host directory (`/home/login/data`) as required by the subject.
