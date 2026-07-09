# Project Structure Adaptation Plan for Village Tree

## Overview

Your existing "Gold Rush" project architecture is already perfectly aligned with Village Tree's requirements (Symfony + React + MySQL + Nginx + Cron). The restructuring is primarily **naming and configuration updates** rather than architectural changes.

## Current Architecture Analysis

Your project uses:
- **Docker Compose** for orchestration with 5 services
- **Nginx** as reverse proxy (routes `/api/*` to Symfony, `/` to React Vite)
- **PHP 8.3-FPM** backend running Symfony
- **Node 20** frontend running React with Vite
- **PHP 8.3-CLI** cron container for scheduled Symfony commands
- **MySQL 8.0** database with health checks
- Unified network bridge (`dochelper_net`) for inter-service communication
- Volume-mounted application code for live development

This architecture is production-ready and supports the entire workflow for Village Tree.

## Changes Required

Update container identifiers, network identifiers, database references, and environment variable names to use "villagetree" prefix instead of "dochelper"/"gold_rush".

### 1. Docker Compose Configuration (`docker-compose.yml`)

**Container Name Changes:**
- `dochelper_db` → `villagetree_db`
- `dochelper_backend` → `villagetree_backend`
- `dochelper_frontend` → `villagetree_frontend`
- `dochelper_nginx` → `villagetree_nginx`
- `dochelper_cron` → `villagetree_cron`

**Network Name Changes:**
- `dochelper_net` → `villagetree_net`

**Database Configuration:**
- Update all database references to use `village_tree` as the primary database name
- Update database user references to `village_tree_user` (or similar)

### 2. Database Initialization (`docker/mysql/init.sql`)

**Database Names:**
- `gold_rush` → `village_tree`
- `gold_rush_test` → `village_tree_test`
- `gold_rush_user` → `village_tree_user`

**Purpose:** Ensure test database and appropriate privileges are set up for Symfony testing.

### 3. Cron Configuration (`docker/cron/crontab`)

**Updates:**
- Change comment from "Gold Rush - Cron Jobs" to "Village Tree - Cron Jobs"
- Replace or update the example precious metals price job to Village Tree–specific scheduled tasks

**Note:** Specific cron jobs for Village Tree are TBD. Placeholder cron entries should be documented until requirements are finalized.

### 4. Backend Dockerfile (`docker/backend/Dockerfile`)

**No architectural changes needed.** Minor updates:
- Update comments from "dochelper" to "villagetree" if present
- Dockerfile uses `COPY backend/ .` which is project-agnostic

### 5. Cron Dockerfile (`docker/cron/Dockerfile`)

**No architectural changes needed.** Minor updates:
- Update comment in `COPY docker/cron/crontab /etc/cron.d/villagetree-cron`
- Change crontab path from `dochelper-cron` to `villagetree-cron`

### 6. Nginx Configuration (`docker/nginx/default.conf`)

**No changes required.** The configuration is generic and works for any Symfony + React architecture:
- Routes `/` to React Vite dev server (port 5173)
- Routes `/api/*` to Symfony via PHP-FPM (port 9000)
- Handles Vite HMR (hot module reloading) correctly
- Properly passes PHP requests through FastCGI

### 7. Environment Configuration (`.env.example` - Create New)

**Required Variables:**
```
APP_ENV=dev
APP_SECRET=<random_secret>
MYSQL_ROOT_PASSWORD=<root_password>
MYSQL_DATABASE=village_tree
MYSQL_USER=village_tree_user
MYSQL_PASSWORD=<user_password>
DB_PORT=3306
BACKEND_PORT=8080
DATABASE_URL=mysql://village_tree_user:${MYSQL_PASSWORD}@db:3306/village_tree?serverVersion=8.0
JWT_SECRET_KEY=/var/www/backend/config/jwt/private.pem
JWT_PUBLIC_KEY=/var/www/backend/config/jwt/public.pem
JWT_PASSPHRASE=<jwt_passphrase>
NODE_ENV=development
```

## Preserved Architecture Elements

✓ **Directory Structure:** `/backend`, `/frontend`, `/docker/` organization remains unchanged
✓ **Service Composition:** 5-service setup (DB, Backend, Frontend, Nginx, Cron) is maintained
✓ **Networking:** Docker bridge network for service communication is preserved
✓ **Volume Mounts:** Live code reloading setup is unchanged
✓ **Health Checks:** Database health checks remain configured
✓ **Reverse Proxy:** Nginx configuration strategy is reusable

## Implementation Sequence

1. Update `docker-compose.yml` (container names, network, database references)
2. Update `docker/mysql/init.sql` (database names and user)
3. Update `docker/cron/crontab` (header comment)
4. Update `docker/backend/Dockerfile` (comments)
5. Update `docker/cron/Dockerfile` (crontab reference)
6. Create `.env.example` with villagetree configuration
7. Verify Nginx configuration is project-agnostic (no changes needed)

## Further Refinement Points

1. **Cron Jobs Definition** – Example precious metals job should be replaced with Village Tree–specific Symfony console commands. Define which scheduled tasks are needed:
   - Background data processing?
   - Notification scheduling?
   - Cache maintenance?
   - Reporting generation?

2. **Environment Variable Naming** – Confirm standard naming:
   - Use `APP_ENV` (Symfony standard) or custom naming?
   - Prefix for Village Tree–specific parameters: `VILLAGETREE_*`, `APP_*`, or domain-specific?

3. **Security Configuration** – Determine if any additional security measures are needed:
   - CORS configuration for React frontend communicating with Symfony API
   - Rate limiting in Nginx
   - Additional firewall rules

4. **Symfony-Specific Configuration** – Post-setup items:
   - `.env.local` secrets management strategy
   - JWT key pair generation
   - Database migration workflow
   - Testing database initialization

5. **Frontend Configuration** – Define Vite environment:
   - Backend API URL (default: http://localhost:8080/api/)
   - Frontend environment variables strategy
   - Build output directory configuration

## Files to Modify

| File | Type | Change |
|------|------|--------|
| `docker-compose.yml` | Config | Update container/network names, DB refs |
| `docker/mysql/init.sql` | Config | Update database and user names |
| `docker/cron/crontab` | Config | Update header, define Village Tree jobs |
| `docker/backend/Dockerfile` | Config | Update comments |
| `docker/cron/Dockerfile` | Config | Update crontab reference |
| `.env.example` | New | Create with villagetree configuration |
| `docker/nginx/default.conf` | Config | No changes (reusable as-is) |

## Deployment Notes

- The unified structure supports both development (with live code mounting) and production (with built images)
- Database backups/exports will use `village_tree` schema
- All Symfony commands should reference the correct database in `DATABASE_URL`
- Cron jobs must be defined relative to `/var/www/backend/` working directory

