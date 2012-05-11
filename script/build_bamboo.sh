#                Initialize environment
# -----------------------------------------------------
#
# This script can run ffcrm plugin tests against various versions of ffcrm.
#
# When TEST_ENV (origin is the default)
#   = master - run plugin tests against ffcrm version detected in ffcrm_app master
#   = live   - run plugin tests against ffcrm version detected in ffcrm_app live
#   = origin - run plugin tests against ffcrm origin/master (this is what plugins
#                  do by default as they have no Gemfile.lock)
#

yum --quiet -y install `yum_bamboo_packages` # Install required yum packages
ruby=`sed -e 's,rvm,,g' -e 's,use,,g' -e 's,\s,,g' .rvmrc`

# Set up RVM environment
# -----------------------------------------------------------------------
#                         app_name   | ruby    | rubygems | bundler
. setup_rvm_environment   ffcrm_app    "$ruby"   1.8.21     1.1.3

RAILS_ENV=test

# run tests on each plugin (extracted by bamboo into ffcrm_* subfolders
for plugin in ffcrm_*
do
  createdb -U postgres "$plugin"_test
  cd $plugin
  if [ "$TEST_ENV" != "origin" ]; then
    # Grab the revision of fat_free_crm from Gemfile.lock to peg the plugin to
    ffcrm_version=`grep -A 1 "https://github.com/fatfreecrm/fat_free_crm.git" ../Gemfile.lock | grep "revision"| cut -d ' ' -f4`
    # replace fat_free_crm with version we want to run against
    sed -i 's/^gem '\''fat_free_crm'\'',/#/g' Gemfile
    echo "gem 'fat_free_crm', :git => 'https://github.com/fatfreecrm/fat_free_crm.git', :ref => '$ffcrm_version'" >> Gemfile
    echo "######## Pegging fat_free_crm to $ffcrm_version"
  fi
  echo
  echo "#########################################################"
  echo "   Running $plugin tests against fat_free_crm $TEST_ENV"
  echo "#########################################################"
  echo
  bundle install
  bundle exec rake db:schema:load
  bundle exec rspec --require ci/reporter/rake/rspec_loader --format CI::Reporter::RSpec spec
  dropdb -U postgres "$plugin"_test
  cd ..
done
