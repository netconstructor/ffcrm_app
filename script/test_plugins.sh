#                Build plugins script
# ----------------------------------------------------------------------
#
# This script grabs our ffcrm plugins and runs each of them
# against the live or master branches of ffcrm. It's our way
# of ensuring any changes to ffcrm don't break the plugins.
#

# Install yum packages
# ----------------------------------------------------------------------
yum --quiet -y install `yum_bamboo_packages`

RUBY = `sed -e 's,rvm,,g' -e 's,use,,g' -e 's,\s,,g' .rvmrc`

# Set up RVM environment
# ----------------------------------------------------------------------
#                         app_name | ruby  | rubygems | bundler
. setup_rvm_environment   ffcrm_app  $RUBY    1.8.21    1.1.3

# Run plugin tests
# ----------------------------------------------------------------------
#
export RAILS_ENV=test

plugins=([ffcrm_mingle]=https://github.com/fatfreecrm/ffcrm_mingle.git)

mkdir plugins
cd plugins
for plugin in ${!plugins[*]}
do
  plugin_url = ${plugins[$plugin]}
  mkdir $plugin
  cd $plugin
  git clone ${plugin_url} .
  sh -c "psql -c 'create database $(plugin)_test;' -U postgres"
  bundle install
  bundle exec rspec --require ci/reporter/rake/rspec_loader --format CI::Reporter::RSpec spec
  sh -c "psql -c 'drop database $(plugin)_test;' -U postgres"
  cd ..
done
