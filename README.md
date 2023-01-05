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
docker compose -f docker-compose.yml up mysql
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
PLATFORM=amd docker compose -f docker-compose.yml up -d
```

### 4. Initialize Search Config

```sh
touch config/_APP.production.yml
```

```ssh
docker exec -ti artelectronics-rails-1 bash
```

```ssh
RAILS_ENV=production bundle exec rake ts:configure
```

### 5. Index data


```ssh
docker exec artelectronics-sphinx-1 indexer --config /opt/sphinx/conf/sphinx.conf --all
```

Restart Sphinx container!

### 5. Run Application

```sh
docker exec -ti artelectronics-rails-1 bash
```

Site has to be available on `http://localhost:3002`

```sh
$ bundle exec puma -C config/_PUMA.production.rb

# or

$ bundle exec rails s -b 0.0.0.0 -p 3000
```

### UPDATE NOTES

```
rake acts_as_taggable_on_engine:install:migrations

It will create any new migrations and skip existing ones

##Breaking changes:

  - ActsAsTaggableOn::Tag is not extend with ActsAsTaggableOn::Utils anymore.
    Please use ActsAsTaggableOn::Utils instead
```
