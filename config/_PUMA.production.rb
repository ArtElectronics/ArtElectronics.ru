workers 1
threads 1, 4
daemonize true
environment "production"

bind "unix:///home/tmp/sockets/puma.sock"

pidfile    "/home/tmp/pids/puma.pid"
state_path "/home/tmp/pids/puma.state"

stdout_redirect \
  "/home/log/puma.log",
  "/home/log/puma.errors.log",
  true

activate_control_app

on_worker_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(YAML.load_file("/home/config/database.yml")["production"])
end
