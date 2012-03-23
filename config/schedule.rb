# Use this file to easily define all of your cron jobs.

# Set up email notifications for errors. Airbrake can only send us errors once the environment has initialized.
env :MAILTO, 'itdept@crossroads.org.hk'

formstack_start, dropbox_start, comments_start = (environment == 'staging') ? [5, 3, 0] : [7, 5, 2]

# Turns (3) into "3,13,23,33,43,53"
def start_min_to_string(start, interval = 10)
  ((start)..(start + 50)).step(interval).to_a.join(',')
end

job_type :rake, "cd :path > /dev/null && RAILS_ENV=:environment bundle exec rake :task --silent :output"

unless environment == 'staging'
  # The following :output conf prints STDERR (and receive emails from cron), and saves STDOUT to log
  every "#{start_min_to_string(formstack_start)} 7-23 * * *" do
    # Formstack submissions
    rake "ffcrm:crossroads:formstack:pull", :output => {:standard => "log/formstack_cron.log"}
  end
end

#TODO Dropbox currently deletes emails on staging too...
unless environment == 'staging'
  every "#{start_min_to_string(dropbox_start)} 7-23 * * *" do
    # Email dropbox
    rake "ffcrm:dropbox:run", :output => {:standard => "log/dropbox_cron.log"}
  end
end


#TODO Comments Replies Inbox currently deletes emails on staging too...
every "#{start_min_to_string(comments_start, 4)} * * * *" do
  # Comments Replies Inbox
  rake "ffcrm:comment_replies:run", :output => {:standard => "log/comment_replies_cron.log"}
end

