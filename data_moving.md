### Data moving

```
development:
  adapter: mysql2
  database: ae_project_new
  username: root
  password:
  host: localhost
  encoding: utf8
  timeout: 5000

old:
  adapter: mysql2
  database: ae_project_old
  host: localhost
  username: root
  password:
  encoding: utf8
  timeout: 5000
```

```
rake db:drop:all
rake db:create:all
```

```
mysql -u root ae_project_old < /path/to/dump.sql
```

```
ERROR 1071 (42000) at line 888: Specified key was too long; max key length is 1000 bytes
```

```
vi /path/to/dump.sql +888
```

remove

```
KEY `index_taggings_on_tag_id` (`tag_id`),
KEY `index_taggings_on_taggable_id_and_taggable_type_and_context` (`taggable_id`,`taggable_type`,`context`)
```

```
mysql -u root ae_project_old < /path/to/dump.sql
```

```
rake ae:data_move
```

### Move new data to server

```sh
mysqldump -u root ae_project_new > ae_project_new.sql
```

```sh
scp ae_project_new.sql ae_project@zykin-ilya.ru:/var/www/ae_project/data/staging.artelectronics.ru/shared/dumps
```

```
cd /var/www/ae_project/data/staging.artelectronics.ru/current &&
rvm use ruby-2.0.0-p247@cap3 &&
RAILS_ENV=production bin/rake db:drop &&
RAILS_ENV=production bin/rake db:create
```

```
mysql -u ae_project -pPASSWORD ae_project_staging < /var/www/ae_project/data/staging.artelectronics.ru/shared/dumps/ae_project_new.sql
```