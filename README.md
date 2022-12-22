# ArtElectronics.ru

## Cold Start

### 0. Pull images

- `PLATFORM=arm` -- default platform
- `PLATFORM=amd`

```sh
PLATFORM=amd docker compose -f docker-compose.yml pull
```

### 1. Initialize Data Base

```sh
docker compose -f dev.docker-compose.yml up mysql
```

### 2. Load a Dump

Put your db dump in the `shared` folder on the host.

```sh
docker exec -ti artelectronics-mysql-1 bash
```

```sh
$ mysql -urails -h localhost -pqwerty artelectronics < shared/artelectronics.2022_10_10.mysql.sql
```

### 3. Run application server

```sh
docker compose -f dev.docker-compose.yml up
```

```sh
docker exec -ti artelectronics-rails-1 bash
```

```sh
$ bundle exec rails s -b 0.0.0.0 -p 3000
```

Site has to be available on `http://localhost:3002`

### 4. Initialize Search Config

```ssh
docker exec -ti artelectronics-rails-1 bash
```

```ssh
RAILS_ENV=production bundle exec rake ts:configure
```

### 5. Index data

```ssh
RAILS_ENV=production bundle exec rake ts:configure
```

```ssh
docker exec artelectronics-sphinx-1 indexer --config /opt/sphinx/conf/sphinx.conf --all
```

Restart Sphinx container!
