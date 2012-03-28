source 'https://rubygems.org'

gem 'bundler_local_development', :group => :development, :require => false
begin
  require 'bundler_local_development'
  Bundler.development_gems = ['fat_free_crm', /^ffcrm_/, 'crossroads_capistrano']
rescue LoadError
end

gem 'fat_free_crm', :git => 'git://github.com/fatfreecrm/fat_free_crm.git', :branch => 'notifications'

gem 'ransack',      :git => "git://github.com/fatfreecrm/ransack.git"
gem 'chosen-rails', :git => "git://github.com/fatfreecrm/chosen-rails.git"
gem 'responds_to_parent', :git => "https://github.com/LessonPlanet/responds_to_parent.git"

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
  gem 'ruby-debug',   :platform => :mri_18
  gem 'ruby-debug19', :platform => :mri_19, :require => 'ruby-debug'
end


# Gems used by Crossroads
#------------------------

gem 'mingle4r',            :git => 'git://github.com/crossroads/mingle4r.git'
gem 'ffcrm_mingle',        :git => 'git://github.com/fatfreecrm/ffcrm_mingle.git'

gem 'ffcrm_merge',         :git => 'git://github.com/fatfreecrm/ffcrm_merge.git'
gem 'ffcrm_service_hooks', :git => 'git://github.com/fatfreecrm/ffcrm_service_hooks.git'

gem 'formstack', '0.0.1'
gem 'ffcrm_crossroads',    :git => 'git@bitbucket.org:crossroadsIT/ffcrm_crossroads.git'

gem 'ffcrm_crossroads_formstack', :git => 'git://github.com/crossroads/ffcrm_crossroads_formstack.git', :branch => 'gem'

gem 'ffcrm_meta_search',   :git => 'git://github.com/crossroads/ffcrm_meta_search.git', :branch => 'gem'

gem 'hoptoad_notifier'
gem 'whenever', '~> 0.7.0'
gem 'crossroads_capistrano', '1.4.42', :group => :development

group :production do
  gem 'newrelic_rpm', '3.3.0'
end

group :production, :staging do
  gem 'soap4r',            :git => 'git://github.com/tribalvibes/soap4r-spox.git'
  gem 'crowd-crossroads',  :git => 'git://github.com/crossroads/crowd.git'
  gem 'crowd_rails',       :git => 'git://github.com/crossroads/crowd_rails.git'
  gem 'ffcrm_crowd',       :git => 'git://github.com/fatfreecrm/ffcrm_crowd.git'
end
