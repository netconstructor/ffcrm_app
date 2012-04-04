# To get going from scratch:
#
# cap deploy:cold
# cap ffcrm:setup
# cap ffcrm:demo

require 'crossroads_capistrano'
load_crossroads_recipes %w(stack rvm passenger postgresql newrelic hoptoad
                           log delayed_job whenever revisions)
load 'deploy/assets'

set :application,        "ffcrm"
set :domain,             "crossroadsint.org"
set :repository,         "git://github.com/crossroads/ffcrm_app.git"
set :rvm_ruby_string,    "ruby-1.9.3-p125"
set :rvm_type,           :root
set :passenger_version,  "3.0.11"
set :yum_packages,       %w(ImageMagick-devel libxml2 libxml2-devel libxslt libxslt-devel)
set :default_stage,      "staging"
set :normalize_asset_timestamps, false

after  "shared:setup",   "ffcrm:shared:setup"
before "deploy:symlink", "ffcrm:shared:symlink"
before "deploy:symlink", "dropbox:create_log"
after  "ffcrm:setup",    "ffcrm:crossroads:seed"

namespace :ffcrm do
  namespace :shared do
    desc "Setup shared directory"
    task :setup do
      sudo "mkdir -p #{deploy_to}/shared/formstack_resumes"
      sudo "mkdir -p #{deploy_to}/shared/avatars"
    end
    desc "Symlink app-specific shared directories"
    task :symlink do
      sudo "ln -sf #{deploy_to}/shared/formstack_resumes/    #{release_path}/public/formstack_resumes"
      sudo "ln -sf #{deploy_to}/shared/avatars/    #{release_path}/public/avatars"
      run  "ln -sf #{deploy_to}/shared/config/settings.yml #{release_path}/config/settings.yml"
    end
  end

  desc "Load crm settings"
  task :settings do
    run "cd #{current_path} && rvmsudo bundle exec rake ffcrm:settings:load RAILS_ENV=#{rails_env}"
    # Clear cached settings
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake tmp:clear"
  end

  namespace :setup do
    desc "Prepare the database and load default application settings (destroys all data)"
    task :default do
      prompt_with_default("Username", :admin_username, "admin")
      prompt_with_default("Password", :admin_password, "admin")
      prompt_with_default("Email", :admin_email, "#{admin_username}@crossroadsint.org")
      run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake ffcrm:setup USERNAME=#{admin_username} PASSWORD=#{admin_password} EMAIL=#{admin_email} PROCEED=true"
    end

   desc "Creates an admin user"
    task :admin do
      prompt_with_default("Username", :admin_username, "admin")
      prompt_with_default("Password", :admin_password, "admin")
      prompt_with_default("Email", :admin_email, "#{admin_username}@crossroadsint.org")
      run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake ffcrm:setup:admin USERNAME=#{admin_username} PASSWORD=#{admin_password} EMAIL=#{admin_email}"
    end
  end

  desc "Load demo data (wipes database)"
  task :demo do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake ffcrm:demo:load"
  end

  desc "Migrates the data to the new custom field schema"
  task :migrate_supertags do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake super_tags:migrate"
  end

  namespace :crossroads do
    desc "Seed crossroads data (tags and customfields, etc.)"
    task :seed do
      run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake ffcrm:crossroads:seed"
    end
  end
end

namespace :dropbox do
  desc "Create dropbox log"
  task :create_log do
    run "if [ ! -f #{shared_path}/log/dropbox.log ]; then sudo -p 'sudo password: ' touch #{shared_path}/log/dropbox.log; fi"
  end

  desc "Run the dropbox crawler"
  task :default do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake ffcrm:dropbox:run"
  end
end

namespace :comment_replies do
  desc "Run the comment inbox crawler"
  task :default do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake ffcrm:comment_replies:run"
  end
end

namespace :formstack do
  desc "Run the formstack crawler"
  task :default do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake ffcrm:crossroads:formstack:pull"
  end
end

namespace :clockit_cache do
  desc "Update cached data from clockit"
  task :default do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake ffcrm:crossroads:update_clockit_cache"
  end
end
