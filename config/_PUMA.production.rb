workers 1
threads 1, 4
daemonize true
environment "production"

bind "unix:///home/lucky/app/tmp/sockets/puma.sock"

pidfile    "/home/lucky/app/tmp/pids/puma.pid"
state_path "/home/lucky/app/tmp/pids/puma.state"

stdout_redirect \
  "/home/lucky/app/log/puma.log",
  "/home/lucky/app/log/puma.errors.log",
  true

activate_control_app

on_worker_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(YAML.load_file("/home/lucky/app/config/database.yml")["production"])
end
