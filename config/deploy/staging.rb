set :stage, :staging

set :branch, "staging"
# If the environment differs from the stage name
set :rails_env, 'staging'

# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server "example.com", user: "deploy", roles: %w{app db web}, my_property: :my_value
# server "example.com", user: "deploy", roles: %w{app web}, other_property: :other_value
server ENV["DEPLOY_SERVER"],
  user: ENV["DEPLOY_USER"],
  roles: [:web, :app],
  ssh_options: {
    user: ENV["DEPLOY_USER"],
    keys: ENV["DEPLOY_SSH_KEY"],
    forward_agent: false,
    auth_methods: %w(publickey)
  }

set :conditionally_migrate, true

set :assets_roles, [:web, :app]
set :rails_assets_groups, :assets

set :keep_assets, 2

namespace :docker do
  task :build do
    on roles(:all) do
      within release_path do
        execute "rm #{release_path}/config/secrets.yml && cp #{shared_path}/config/secrets.yml #{release_path}/config/secrets.yml"

        execute "rm #{release_path}/config/master.key && cp #{shared_path}/config/master.key #{release_path}/config/master.key"
        
        execute "rm #{release_path}/config/storage.yml && cp #{shared_path}/config/storage.yml #{release_path}/config/storage.yml"
        
        execute "rm #{release_path}/config/database.yml && cp #{shared_path}/config/database.yml #{release_path}/config/database.yml"

        execute "rm #{release_path}/docker-compose.yml && cp #{shared_path}/docker-compose.yml #{release_path}/docker-compose.yml"

        execute "rm #{release_path}/docker/web/nginx.conf && cp #{shared_path}/docker/web/nginx.conf #{release_path}/docker/web/nginx.conf"
        
        execute "docker-compose -p #{fetch(:application)} -f #{release_path}/docker-compose.yml build app"

        execute "docker-compose -p #{fetch(:application)} -f #{release_path}/docker-compose.yml build web"
      end
    end
  end

  desc "Docker container stop"
  task :stop do
    on roles(:all) do
      within release_path do
        execute "docker-compose -p #{fetch(:application)} -f #{release_path}/docker-compose.yml stop -t 30 web && docker-compose -p #{fetch(:application)} -f #{release_path}/docker-compose.yml rm --force -v web"

        execute "docker-compose -p #{fetch(:application)} -f #{release_path}/docker-compose.yml stop -t 30 app && docker-compose -p #{fetch(:application)} -f #{release_path}/docker-compose.yml rm --force -v app"
      end
    end
  end

  desc "Docker container start"
  task :start do
    on roles(:all) do
      within release_path do
        execute "docker-compose -p #{fetch(:application)} -f #{release_path}/docker-compose.yml up --no-recreate -d web"
      end
    end
  end

  desc "Docker container debug"
  task :debug do
    on roles(:all) do
      within release_path do
        execute "docker-compose -p #{fetch(:application)} -f #{release_path}/docker-compose.yml up --no-recreate web"
      end
    end
  end

  desc "Docker container access"
  task :bash do
    on roles(:all) do
      within release_path do
        execute "docker-compose -p #{fetch(:application)} -f #{release_path}/docker-compose.yml run web /bin/bash"
      end
    end
  end

  desc "Build project"
  task :migrate do
    on roles(:all) do
      within release_path do
        execute "docker-compose -p #{fetch(:application)} -f #{release_path}/docker-compose.yml run web rake db:migrate"  
      end
    end
  end

  desc "Docker images"
  task :images do
    on roles(:all) do
      within release_path do
        execute "docker images"
      end
    end
  end

  desc "Docker list containers"
  task :ps do
    on roles(:all) do
      within release_path do
        execute "docker ps"
      end
    end
  end

  desc "Remove networks"
  task :remove_networks do
    on roles(:app) do
      execute "cd #{current_path} && docker network ls | grep bridge"
      execute "cd #{current_path} && docker network rm $(docker network ls | grep bridge | awk '/ / { print $1 }')"
    end
  end

  desc "Setup Database"
  task :setup_db do
    on roles(:app) do
      execute "docker-compose -p #{fetch(:application)} -f #{release_path}/docker-compose.yml run app rails db:create db:migrate db:seed"
    end
  end

  desc "Run assets:precompile"
  task :assets do
    on roles(:app) do
      execute "docker-compose -p #{fetch(:application)} -f #{release_path}/docker-compose.yml run app rake assets:clean"
      execute "docker-compose -p #{fetch(:application)} -f #{release_path}/docker-compose.yml run app rake assets:precompile"
    end
  end

  desc "Reset Database"
  task :reset_db do
    on roles(:app) do
      execute "docker-compose -p #{fetch(:application)} -f #{release_path}/docker-compose.yml run app rails db:drop db:create db:migrate db:seed"
    end
  end

end

namespace :deploy do
  after :publishing, 'docker:stop'
  after :publishing, 'docker:build'
  after :publishing, 'docker:start'
end