source :rubygems

gem 'bundler_local_development', :group => :development, :require => false
begin
  require 'bundler_local_development'
  Bundler.development_gems = ['fat_free_crm', /^ffcrm_/, 'crossroads_capistrano']
rescue LoadError
end

gem 'fat_free_crm', :git => 'https://github.com/fatfreecrm/fat_free_crm.git', :branch => "cancan"

# Allow textile markup in emails and comments
gem 'RedCloth'

# Uncomment the database that you have configured in config/database.yml
# ----------------------------------------------------------------------
# gem 'mysql2', '0.3.10'
# gem 'sqlite3'
gem 'pg', '~> 0.12.2'

group :heroku do
  gem 'unicorn', :platform => :ruby
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'therubyracer', :platform => :ruby  # C Ruby (MRI) or Rubinius, but NOT Windows
  gem 'uglifier',     '>= 1.0.3'
end

group :development, :test do
  gem 'ruby-debug', :platform => :mri_18
  gem 'debugger',   :platform => :mri_19
end


# Gems used by Crossroads
#------------------------

gem 'mingle4r',            :git => 'git://github.com/crossroads/mingle4r.git'
gem 'ffcrm_mingle',        :git => 'https://github.com/fatfreecrm/ffcrm_mingle.git'

gem 'ffcrm_merge',         :git => 'https://github.com/fatfreecrm/ffcrm_merge.git'
gem 'ffcrm_service_hooks', :git => 'https://github.com/fatfreecrm/ffcrm_service_hooks.git'

gem 'formstack', '0.0.1'
gem 'ffcrm_crossroads',    :git => 'git@bitbucket.org:crossroadsIT/ffcrm_crossroads.git'

gem 'ffcrm_crossroads_formstack', :git => 'https://github.com/crossroads/ffcrm_crossroads_formstack.git'

gem 'ffcrm_meta_search',   :git => 'https://github.com/crossroads/ffcrm_meta_search.git'

gem 'ffcrm_authlogic_api', :git => 'https://github.com/crossroads/ffcrm_authlogic_api.git'

gem 'hoptoad_notifier'
gem 'whenever', '~> 0.7.0'
gem 'crossroads_capistrano', :git => 'git://github.com/crossroads/crossroads_capistrano.git', :group => :development
gem 'rails-erd', :group => :development

group :production do
  gem 'newrelic_rpm', '3.3.0'
end

group :production, :staging do
  gem 'soap4r',            :git => 'https://github.com/tribalvibes/soap4r-spox.git'
  gem 'crowd-crossroads',  :git => 'https://github.com/crossroads/crowd.git'
  gem 'crowd_rails',       :git => 'https://github.com/crossroads/crowd_rails.git'
  gem 'ffcrm_crowd',       :git => 'https://github.com/fatfreecrm/ffcrm_crowd.git'
end
