# Use this file to easily define all of your cron jobs.

# Set up email notifications for errors. Airbrake can only send us errors once the environment has initialized.
env :MAILTO, 'itdept@crossroads.org.hk'

formstack_start, dropbox_start = (environment == 'staging') ? [3, 0] : [5, 2]

# Turns (3) into "3,13,23,33,43,53"
def start_min_to_string(start)
  ((start)..(start + 50)).step(10).to_a.join(',')
end
formstack_mins = start_min_to_string(formstack_start)
dropbox_mins = start_min_to_string(dropbox_start)

job_type :rake, "cd :path > /dev/null && RAILS_ENV=:environment bundle exec rake :task --silent :output"

# The following :output conf prints STDERR (and receive emails from cron), and saves STDOUT to log
every "#{formstack_mins} 7-23 * * *" do
  # Formstack submissions
  rake "ffcrm:crossroads:formstack:pull", :output => {:standard => "log/formstack_cron.log"}
end

#TODO Dropbox currently deletes emails on staging too...
unless environment == 'staging'
  every "#{dropbox_mins} 7-23 * * *" do
    # Email dropbox
    rake "ffcrm:dropbox:run", :output => {:standard => "log/dropbox_cron.log"}
  end
end
