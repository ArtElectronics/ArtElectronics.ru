### HOW TO INSTALL 

Create project dir

```
mkdir rails4
cd rails4
```

Clone project

```
git git@github.com:ArtElectronics/ArtElectronics.ru.git
```

Clone gems repos

```
git clone git@github.com:open-cook/the_audit.git
git clone git@github.com:the-teacher/the_role.git
git clone git@github.com:the-teacher/the_comments.git
git clone git@github.com:the-teacher/the_storages.git
git clone git@github.com:the-teacher/the_notification.git
git clone git@github.com:the-teacher/the_sortable_tree.git
```

Change directory

```
cd ArtElectronics.ru
```

Create DB config file

```
touch config/database.yml
```

Open config file and puts following config text:

**config/database.yml**

```
development:
  adapter: sqlite3
  database: db/development.db

test:
  adapter: sqlite3
  database: db/test.db
```

Bundle!

```
bundle
```

Create DB and test data

```
rake db:bootstrap_and_seed
```

DJ run

```
script/delayed_job start
```

web server run

```
bin/rails s
```

or

```
bin/rails s -p 3000 -b host.name
```

#### tests

```
rake db:bootstrap RAILS_ENV=test
rspec

rspec spec/requests --format documentation
```