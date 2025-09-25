# initHost

This project was initialized with [init.web.ap.it](https://init.web.ap.it) — a free, open-source installer for Laravel & Filament.

---

## Endpoints

| Service         | URL             |
| --------------- | --------------- |
| **App**         | `initUrl`       |
| **Admin panel** | `initUrl/panel` |
| **Mailpit**     | `initMailpit`   |
| **MinIO**       | `initMinio`     |
| **MySQL**       | `initMysql`     |
| **Redis**       | `initRedis`     |

**Admin panel default credentials:** `test@example.com` / `password`  
**MinIO default credentials:** `sail` / `password`

---

## Requirements

All you need to run this project is [Docker Desktop](https://www.docker.com/products/docker-desktop) on macOS.

---

## Getting started

If you're setting up the project for the first time on a new machine, run:

```bash
sh bin/setup.sh
```

> If the project was already initialized on your machine by the installer, skip this step.

---

## Development scripts

All day-to-day operations are wrapped in short scripts inside the `bin/` directory.

**Start the project**

```bash
sh bin/start.sh
```

**Stop the project**

```bash
sh bin/stop.sh
```

**Run tests**

```bash
sh bin/test.sh
```

**Fix code style** (Laravel Pint)

```bash
sh bin/pint.sh
```

**Static analysis** (PHPStan / Larastan)

```bash
sh bin/stan.sh
```

**Start queue worker**

```bash
sh bin/jobs.sh
```

**Clear all caches**

```bash
sh bin/cache.sh
```

**Refresh database** (drop, migrate, seed)

```bash
sh bin/fresh.sh
```

**Open a bash shell** inside the app container

```bash
sh bin/bash.sh
```

---

Powered by [127001.it](https://127001.it) · Take it to production, use [Cipi](https://cipi.sh) to deploy your project!
