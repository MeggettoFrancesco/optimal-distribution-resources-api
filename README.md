Optimal Distribution of Resources - API
=======================================

# Introduction

Optimal Distribution of Resources (ODR) API is the API application, host of the algorithmic logic to solve the distribution of resources.

It provides two endpoints:
* POST /api/v1/requests
* GET /api/v1/requests/:id

# Start Application Locally

Docker takes care of running every needed dependecy:

```
docker-compose up
```

Here is what is included in the docker-compose stack:
* MySQL
* Redis
* Rails server (puma)
* Sidekiq

This application runs on domain `localhost` and port `3001`.

## Rails: create and seed database

To create and seed your database, run:

```
docker-compose exec app rails db:reset
```

## Admin Dashboard

* Visit http://localhost:3001/admin
  * Username: `admin@example.com`
  * Password: `password`

## Sidekiq Dashboard

* Visit http://localhost:3001/sidekiq
  * Username and password are the same as in the previous section: `admin@example.com`, `password`
