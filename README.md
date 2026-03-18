# 🚀 init

> One command. Full local stack. Zero manual config.

**init** is a free, open-source installer that scaffolds a complete Laravel + Filament local environment on your Mac in seconds — no Homebrew, no global packages, no hosts file edits.

---

## What's included

| Tool               | Version | Purpose                      |
| ------------------ | ------- | ---------------------------- |
| Laravel            | 13      | Application framework        |
| Filament           | 5       | Admin panel & form builder   |
| Laravel Sail       | latest  | Docker-based dev environment |
| MySQL              | 8       | Relational database          |
| Redis              | latest  | Cache & queue backend        |
| Mailpit            | latest  | Local email testing UI       |
| MinIO              | latest  | S3-compatible local storage  |
| Caddy              | latest  | Reverse proxy with local SSL |
| PHPStan / Larastan | latest  | Static analysis              |
| Laravel Pint       | latest  | Code style fixer             |
| Laravel Boost      | latest  | Dev productivity tools       |
| GitHub Actions     | —       | CI workflow preconfigured    |

Every project also gets:

- **A real `*.127001.it` subdomain** — no `/etc/hosts` edits, powered by [127001.it](https://127001.it)
- **A trusted local SSL certificate** — HTTPS with no browser warnings, via Caddy `tls internal`
- **A full set of dev helper scripts** — start, stop, test, lint, analyse, and more

---

## Requirements

All you need is [Docker Desktop](https://www.docker.com/products/docker-desktop) on macOS.

---

## Getting started

```bash
curl https://init.web.ap.it/bin/go.sh > go.sh && sh go.sh
```

The installer will:

1. Check that Docker is running
2. Ask you to choose a project subdomain (e.g. `my-app` → `my-app.127001.it`)
3. Create all helper scripts
4. Scaffold a fresh Laravel 13 project
5. Configure environment, Docker Compose, and Caddy
6. Set up GitHub Actions CI workflow
7. Start all Docker containers via Sail
8. Run database migrations and seeders
9. Install Filament and configure the admin panel
10. Install additional packages (S3, PHPStan, Boost)
11. Adjust file permissions
12. Install and trust the local SSL certificate

Once done, it prints all your endpoints:

```
APP    https://my-app.127001.it
PANEL  https://my-app.127001.it/panel  (test@example.com / password)
MAIL   http://my-app.127001.it:<mailpit-port>
MINIO  http://my-app.127001.it:<minio-port>  (sail / password)
MYSQL  mysql://sail:password@my-app.127001.it:<db-port>/my_app_db
REDIS  redis://default@my-app.127001.it:<redis-port>
```

---

## Generated project scripts

Every generated project ships with a `bin/` directory of helper scripts:

| Script     | Command           | Description                                         |
| ---------- | ----------------- | --------------------------------------------------- |
| Setup      | `sh bin/setup.sh` | First-run install (skip if you ran the initializer) |
| Start      | `sh bin/start.sh` | Start all Docker containers                         |
| Stop       | `sh bin/stop.sh`  | Stop all Docker containers                          |
| Test       | `sh bin/test.sh`  | Run the test suite via PHPUnit                      |
| Lint       | `sh bin/pint.sh`  | Fix code style with Laravel Pint                    |
| Analyse    | `sh bin/stan.sh`  | Run static analysis with PHPStan/Larastan           |
| Jobs       | `sh bin/jobs.sh`  | Start the queue worker                              |
| Cache      | `sh bin/cache.sh` | Clear all application caches                        |
| DB Refresh | `sh bin/fresh.sh` | Drop, migrate, and re-seed the database             |
| Bash       | `sh bin/bash.sh`  | Open a bash shell inside the app container          |

---

## Powered by 127001.it

Every project gets a real subdomain under `*.127001.it` — a free wildcard DNS service that resolves every subdomain to `127.0.0.1`. Nothing leaves your machine.

```
TYPE  NAME          VALUE
A     *.127001.it   127.0.0.1   ; wildcard — all subdomains resolve locally
```

→ Learn more at [127001.it](https://127001.it)

---

## Take it to production — cipi.sh

Once your app is ready, deploy it to any Ubuntu VPS with [cipi.sh](https://cipi.sh) — an open-source CLI built exclusively for Laravel.

- Full app isolation — own Linux user, PHP-FPM pool & database per app
- Zero-downtime deploys with instant rollback via Deployer
- Let's Encrypt SSL, Fail2ban, UFW firewall — all automated
- Multi-PHP (7.4 → 8.5), queue workers, S3 backups, auto-deploy webhooks
- AI Agent ready — built-in MCP server with tools (health, deploy, logs, db_query, artisan). Works with Cursor, VS Code, Claude Desktop. No SSH required.

```bash
wget -O - https://cipi.sh/setup.sh | bash
```

→ Learn more at [cipi.sh](https://cipi.sh)

---

## Contributing

Thank you for considering contributing! Feel free to open Pull Requests or Issues on [GitHub](https://github.com/andreapollastri/init.web.ap.it).

## License

Open-source software licensed under the [MIT license](https://opensource.org/licenses/MIT).
