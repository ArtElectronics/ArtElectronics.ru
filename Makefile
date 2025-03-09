# cloudflare.com
# gkillich@gmail.com
# iamteacher/artelectronics.ru
digitalocean:
	@echo "login: killich"
	@echo "email: zykin-ilya@yandex.ru"
	@echo "password: !*6a4ce4f679*!"

firstvds:
	@echo "login: root"
	@echo "login: killich"
	@echo "email: zykin-ilya@ya.ru"
	@echo "password (2025): Jgj2QUYTbWKAJgj2QUYTbWKA"

root_shell:
	@echo "password: dkGRaWTxsjbrF5zN"
	ssh root@64.227.65.207

lucky_shell:
	@echo "password: 6BmohMp5h3YXsB94sG"
	ssh lucky@open-cook.ru

up:
	docker compose -f ./docker/docker-compose.yml up

status:
	docker compose  -f ./docker/docker-compose.yml ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"

stop:
	make down

down:
	docker compose -f ./docker/docker-compose.yml down

########################################################################
# DUMP DATA 
########################################################################

DB_NAME=artelectronics
SQL_DUMP_FILE=artelectronics_$(shell date +%Y-%m-%d).dump.sql

dump:
	make sql_dump

sql_dump:
	@echo "Creating MySQL database dump on remote server..."
	@echo "password: 6BmohMp5h3YXsB94sG"
	@ssh lucky@open-cook.ru \
		'if [ ! -f "/home/lucky/artelectronics.ru/shared/$(SQL_DUMP_FILE)" ]; then \
		   docker exec artelectronics-mysql-1 sh -c "mysqldump -u rails -pqwerty --no-tablespaces artelectronics > /shared/$(SQL_DUMP_FILE)"; \
		 else \
		   echo "File /home/lucky/artelectronics.ru/shared/$(SQL_DUMP_FILE) already exists. Skipping dump."; \
		 fi'
	@echo "MySQL database dump completed."

copy_dump:
	@echo "Downloading database dump..."
	@echo "password: 6BmohMp5h3YXsB94sG"
	rsync -avzP lucky@open-cook.ru:/home/lucky/artelectronics.ru/shared/$(SQL_DUMP_FILE) ./shared/$(SQL_DUMP_FILE)
	@echo "Database dump download completed."

delete_dump:
	@echo "Deleting database dump..."
	@echo "password: 6BmohMp5h3YXsB94sG"
	ssh lucky@open-cook.ru 'rm -f /home/lucky/artelectronics.ru/shared/$(SQL_DUMP_FILE) && ls -al /home/lucky/artelectronics.ru/shared/'
	@echo "Database dump deletion completed."

sync_assets:
	@echo "password: 6BmohMp5h3YXsB94sG"
	rsync -chavzPr lucky@open-cook.ru:/home/lucky/artelectronics.ru/public/ ./public/

# linux/amd64

########################################################################
# COMMON
########################################################################

build_arm64:
	docker buildx build --platform linux/arm64 -t iamteacher/artelectronics.ru -f ./docker/Dockerfile . --no-cache

build_amd64:
	docker buildx build --platform linux/amd64 -t iamteacher/artelectronics.ru -f ./docker/Dockerfile . --no-cache

rebuild_amd64:
	docker build --platform linux/amd64 -t iamteacher/artelectronics.ru -f ./docker/Dockerfile . --no-cache

rebuild_arm64:
	docker build --platform linux/arm64 -t iamteacher/artelectronics.ru -f ./docker/Dockerfile . --no-cache

# up:
# 	docker compose -f ./docker/docker-compose.yml up --detach rails


########################################################################
# POSTGRESQL
########################################################################

psql_shell:
	docker compose -f ./docker/docker-compose.yml exec psql bash

psql_console:
	docker compose -f ./docker/docker-compose.yml exec psql psql -U postgres -d stereo_shop_dev -h localhost


########################################################################
# NGINX
########################################################################

nginx_up:
	docker compose -f ./docker/docker-compose.yml up --detach nginx
	# docker compose -f ./docker/docker-compose.yml up nginx

nginx_shell:
	docker compose -f ./docker/docker-compose.yml exec nginx bash

nginx_stop:
	docker compose -f ./docker/docker-compose.yml exec nginx bash -c "nginx -s stop"

nginx_start:
	docker compose -f ./docker/docker-compose.yml exec --detach nginx bash -c "nginx"

nginx_restart:
	docker compose -f ./docker/docker-compose.yml exec nginx bash -c "nginx -s reload"

nginx_status:
	docker compose -f ./docker/docker-compose.yml exec nginx bash -c "ps aux | grep nginx"

nginx_down:
	docker compose -f ./docker/docker-compose.yml down nginx

# Chrome: type `thisisunsafe` to pass the warning
create_ssl:
	mkdir -p ./ssl
	openssl dhparam -out ./ssl/ssl-dhparams.pem 2048
	openssl genrsa -out ./ssl/privkey.pem 2048
	openssl req -new -x509 \
		-key ./ssl/privkey.pem \
		-out ./ssl/fullchain.pem \
		-days 365 \
		-subj "/C=RU/ST=Saint Petersburg/L=Saint Petersburg/O=Stereo Shop RU/OU=IT/CN=stereo-shop.ru/emailAddress=admin@stereo-shop.ru"

########################################################################
# REDIS
########################################################################

redis_up:
	docker compose -f ./docker/docker-compose.yml up --detach redis

redis_start:
	docker compose -f ./docker/docker-compose.yml exec --detach redis bash -c "redis-server --save 60 1 --loglevel warning"

redis_shell:
	docker compose -f ./docker/docker-compose.yml exec redis bash

redis_stop:
	docker compose -f ./docker/docker-compose.yml exec redis bash -c "redis-cli shutdown"

redis_down:
	docker compose -f ./docker/docker-compose.yml down redis

########################################################################
# SPHINX
########################################################################

search_build:
	docker compose -f ./docker/docker-compose.yml build sphinx

update_dockerhub:
	make search_build
	docker push iamteacher/sphinx_232:latest

search_up:
	docker compose -f ./docker/docker-compose.yml up --detach sphinx

search_shell:
	make search_up
	docker compose -f ./docker/docker-compose.yml exec sphinx bash

rails_search_config:
	docker compose -f ./docker/docker-compose.yml exec rails bash -c "source ~/.bashrc && RAILS_ENV=development bundle exec rake ts:configure"

rails_search_config_prod:
	docker compose -f ./docker/docker-compose.yml exec rails bash -c "source ~/.bashrc && RAILS_ENV=production bundle exec rake ts:configure"

search_index:
	docker compose -f ./docker/docker-compose.yml exec sphinx bash -c "cd /var/lib/sphinxsearch/data && indexer --config /var/lib/sphinxsearch/data/sphinx.conf --all"

search_start:
	make search_up
	docker compose -f ./docker/docker-compose.yml exec sphinx bash -c "cd /var/lib/sphinxsearch/data && searchd --config /var/lib/sphinxsearch/data/sphinx.conf"

search_stop:
	docker compose -f ./docker/docker-compose.yml exec sphinx bash -c "cd /var/lib/sphinxsearch/data && searchd --config /var/lib/sphinxsearch/data/sphinx.conf --stop"

search_status:
	docker compose -f ./docker/docker-compose.yml exec sphinx bash -c "ps aux | grep searchd"

search_reset:
	docker compose -f ./docker/docker-compose.yml exec sphinx bash -c "cd /var/lib/sphinxsearch/data && indexer --config /var/lib/sphinxsearch/data/sphinx.conf --rotate --all"

search_down:
	docker compose -f ./docker/docker-compose.yml down sphinx

search_cron_show:
	docker compose -f ./docker/docker-compose.yml exec sphinx bash -c "crontab -l"

search_cron_reset:
	docker compose -f ./docker/docker-compose.yml exec sphinx bash -c "crontab -r"

search_cron_update:
	make search_cron_reset
	docker compose -f ./docker/docker-compose.yml exec sphinx bash -c "(crontab -l 2>/dev/null; echo '* * * * * cd /var/lib/sphinxsearch/data && indexer --config /var/lib/sphinxsearch/data/sphinx.conf --all >> /var/lib/sphinxsearch/data/log/sphinx_indexer.log 2>&1') | crontab -"

search_cron_start:
	docker compose -f ./docker/docker-compose.yml exec sphinx bash -c "service cron start"

search_cron_status:
	docker compose -f ./docker/docker-compose.yml exec sphinx bash -c "service cron status"

########################################################################
# RAILS
########################################################################

rails_git_fix:
	docker compose -f ./docker/docker-compose.yml exec rails bash -c "cd /home/lucky/app && git config --global --add safe.directory /home/lucky/app"

rails_up:
	make up
	make rails_git_fix

rails_migrate:
	docker compose -f ./docker/docker-compose.yml exec rails bash -c "source ~/.bashrc && RAILS_ENV=development bundle exec rake db:migrate"

rails_bundle:
	docker compose -f ./docker/docker-compose.yml exec rails bash -c "source ~/.bashrc && bundle install"

rails_start:
	make rails_bundle
	docker compose -f ./docker/docker-compose.yml exec --detach rails bash -c "source ~/.bashrc && rails s -p 3000 -b 0.0.0.0"

rails_stop:
	docker compose -f ./docker/docker-compose.yml exec rails bash -c "kill -9 `cat tmp/pids/server.pid`"

rails_status:
	docker compose -f ./docker/docker-compose.yml exec rails bash -c "ps aux | grep rails"

rails_shell:
	docker compose -f ./docker/docker-compose.yml exec rails bash

rails_root_shell:
	docker compose -f ./docker/docker-compose.yml exec --user root rails bash

install_tools:
	docker compose -f ./docker/docker-compose.yml exec --user root rails bash -c "apt-get update && apt-get install -y vim nano htop procps cron"
	docker compose -f ./docker/docker-compose.yml exec --user root redis bash -c "apt-get update && apt-get install -y procps"
	docker compose -f ./docker/docker-compose.yml exec --user root nginx bash -c "apt-get update && apt-get install -y procps"

########################################################################
# PRODUCTION
########################################################################

rails_puma_start_prod:
	make rails_bundle
	docker compose -f ./docker/docker-compose.yml exec --detach rails bash -c "source ~/.bashrc && RAILS_ENV=production bundle exec puma -C config/_PUMA_PRODUCTION.rb"
	# docker compose -f ./docker/docker-compose.yml exec rails bash -c "source ~/.bashrc && RAILS_ENV=production bundle exec puma -C config/_PUMA_PRODUCTION.rb"

rails_puma_stop_prod:
	docker compose -f ./docker/docker-compose.yml exec rails bash -c "kill -9 `cat tmp/pids/puma.pid`"
	docker compose -f ./docker/docker-compose.yml exec rails bash -c "rm -f tmp/pids/puma.pid"

rails_assets_clean:
	docker compose -f ./docker/docker-compose.yml exec rails bash -c "source ~/.bashrc && RAILS_ENV=production bundle exec rake assets:clean"

rails_migrate_prod:
	docker compose -f ./docker/docker-compose.yml exec rails bash -c "source ~/.bashrc && RAILS_ENV=production bundle exec rake db:migrate"	

rails_assets_precompile:
	make rails_assets_clean
	docker compose -f ./docker/docker-compose.yml exec rails bash -c "source ~/.bashrc && RAILS_ENV=production bundle exec rake assets:precompile"

########################################################################
# SYSTEM STATUS
########################################################################

system_status:
	@echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	@echo "System status: RAILS:"
	@echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	docker compose -f ./docker/docker-compose.yml exec rails bash -c "ps aux | grep rails"
	docker compose -f ./docker/docker-compose.yml exec rails bash -c "ps aux | grep puma"
	@echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	@echo "System status: SIDEKIQ:"
	@echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	docker compose -f ./docker/docker-compose.yml exec rails bash -c "ps aux | grep sidekiq"
	@echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	@echo "System status: RAILS CRON:"
	@echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	docker compose -f ./docker/docker-compose.yml exec rails bash -c "service cron status"
	@echo "System status: SPHINX:"
	docker compose -f ./docker/docker-compose.yml exec sphinx bash -c "ps aux | grep searchd"
	@echo "System status: SPHINX CRON:"
	docker compose -f ./docker/docker-compose.yml exec sphinx bash -c "service cron status"
	@echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	@echo "System status: REDIS:"
	@echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	docker compose -f ./docker/docker-compose.yml exec redis bash -c "ps aux | grep redis"
	@echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	@echo "System status: NGINX:"
	@echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	docker compose -f ./docker/docker-compose.yml exec nginx bash -c "ps aux | grep nginx"
	@echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

# service cron start (as root)

rails_cron_start:
	docker compose -f ./docker/docker-compose.yml exec --user root rails bash -c "service cron start"

rails_cron_update:
	docker compose -f ./docker/docker-compose.yml exec rails bash -c "whenever --update-crontab --load-file config/_WHENEVER.rb --set 'environment=development'"

rails_cron_show:
	docker compose -f ./docker/docker-compose.yml exec rails bash -c "crontab -l"

rails_cron_clear:
	docker compose -f ./docker/docker-compose.yml exec rails bash -c "whenever --clear-crontab --load-file config/_WHENEVER.rb --set 'environment=development'"

rails_cron_stop:
	docker compose -f ./docker/docker-compose.yml exec --user root rails bash -c "service cron stop"

########################################################################
# RAILS SIDEKIQ
########################################################################

rails_sidekiq_start:
	docker compose -f ./docker/docker-compose.yml exec --detach rails bash -c "source ~/.bashrc && bundle exec sidekiq --config config/_SIDEKIQ.yml"

rails_sidekiq_stop:
	docker compose -f ./docker/docker-compose.yml exec rails bash -c "kill -9 `cat tmp/pids/sidekiq.pid`"

########################################################################
LOCAL_DB_NAME="stereo_shop_dev"

# pwd: 9uQHQMjApwnq5v9uQHQMjApwnq5v
db_reset:
	@echo "Dropping database $(LOCAL_DB_NAME)..."
	docker compose -f ./docker/docker-compose.yml exec psql dropdb -U postgres $(LOCAL_DB_NAME)
	@echo "Creating database $(LOCAL_DB_NAME)..."
	docker compose -f ./docker/docker-compose.yml exec psql createdb -U postgres $(LOCAL_DB_NAME)
	@echo "Database $(LOCAL_DB_NAME) reset completed."

# pwd: 9uQHQMjApwnq5v9uQHQMjApwnq5v
db_restore:
	@echo "Restoring database $(LOCAL_DB_NAME) from $(BIN_DUMP_FILE)..."
	docker compose -f ./docker/docker-compose.yml exec psql pg_restore  --no-owner --clean --if-exists -U postgres -d $(LOCAL_DB_NAME) /shared/$(BIN_DUMP_FILE)
	@echo "Database $(LOCAL_DB_NAME) restored successfully."

db_reset_local_prod:
	@echo "Dropping database stereo_shop..."
	docker compose -f ./docker/docker-compose.yml exec psql dropdb -U postgres stereo_shop_production
	@echo "Creating database stereo_shop..."
	docker compose -f ./docker/docker-compose.yml exec psql createdb -U postgres stereo_shop_production
	@echo "Database stereo_shop reset completed."

db_create_local_prod:
	@echo "Creating database stereo_shop..."
	docker compose -f ./docker/docker-compose.yml exec psql createdb -U postgres stereo_shop_production
	@echo "Database stereo_shop created successfully."

db_restore_local_prod:
	@echo "Restoring database stereo_shop from $(BIN_DUMP_FILE)..."
	docker compose -f ./docker/docker-compose.yml exec psql pg_restore  --no-owner --clean --if-exists -U postgres -d stereo_shop_production /shared/$(BIN_DUMP_FILE)
	@echo "Database stereo_shop restored successfully."
########################################################################

# pwd: 9uQHQMjApwnq5v9uQHQMjApwnq5v
server:
	ssh root@188.226.144.8

# pwd: 6BmohMp5h3YXsB94sG
new_server:
	ssh lucky@open-cook.ru

# pwd: 6BmohMp5h3YXsB94sG
add_new_server_remote:
	git remote add new-server lucky@open-cook.ru:/home/lucky/BARE/stereo-shop.ru-bare

make push_new_server:
	git push new-server master

# pwd: 6BmohMp5h3YXsB94sG
new_server_root:
	ssh root@open-cook.ru

# pwd: 6BmohMp5h3YXsB94sG
copy_to_new_server:
	rsync -avzP --ignore-errors --exclude='db/*' . lucky@open-cook.ru:/home/lucky/stereo-shop.ru

# /home/projects-assets/
# copy projects assets to local temp folder
copy_project_assets:
	rsync -avzP lucky@open-cook.ru:/home/projects-assets/ ./tmp/projects-assets/


# echo "" > /home/lucky/artelectronics.ru/log/production.log
# echo "" > /home/lucky/eastflower.ru/log/production.log 
# echo "" > /home/lucky/open-cook.ru/log/production.log 

# artelectronics.ru
# docker exec -it artelectronics-mysql-1 /bin/bash
# mysql -u root -p
# PURGE BINARY LOGS BEFORE '2024-12-01 00:00:00';

dirs:
	mkdir -p db/PGSQL
	mkdir -p db/REDIS
	mkdir -p db/SPHINX

# NGINX COMMANDS
# service nginx start
# service nginx stop	
# service nginx configtest -v
# service nginx restart