
rails_env = ENV.fetch("RAILS_ENV") { "development" }
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
app_path = ENV.fetch("APP_PATH") { "/app" }

workers 2
threads threads_count, threads_count
port 8666
environment rails_env
if rails_env != "development"
  stdout_redirect "#{app_path}/log/#{rails_env}.log",
                  "#{app_path}/log/#{rails_env}.error.log",
                  true
end
state_path "#{app_path}/shared/pids/puma.state"
pidfile "#{app_path}/shared/pids/puma.pid"
plugin :tmp_restart