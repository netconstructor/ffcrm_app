set :user, "root"
set :use_sudo, false

set :ip_address, "192.168.0.149"
set :site_domain_name, "crm.crossroads.org.hk"

set :application,  "crm"

server ip_address, :app, :web, :db, :primary => true

set :deploy_to, "/opt/rails/#{application}-#{stage}"

set :branch, (ENV['branch'] || "live")
