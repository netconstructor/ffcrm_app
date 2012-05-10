#                Initialize environment
# -----------------------------------------------------
yum --quiet -y install `yum_bamboo_packages` # Install required yum packages

# Set up RVM environment
# -----------------------------------------------------------------------
#                         app_name   | ruby            | rubygems | bundler
. setup_rvm_environment   ffcrm_app    ruby-1.9.3-p125   1.8.21     1.1.3

# Install bundled gems
bundle install

RAILS_ENV=test
plugins="ffcrm_mingle ffcrm_meta_search"
# run tests on each plugin
for plugin in $plugins
do
  psql -c 'create database $(plugin)_test;' -U postgres
  cd $plugin
  bundle install
  bundle exec rake db:schema:load
  bundle exec rspec --require ci/reporter/rake/rspec_loader --format CI::Reporter::RSpec spec
  psql -c 'drop database $(plugin)_test;' -U postgres
done
