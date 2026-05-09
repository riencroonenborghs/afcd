# Capfile
require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/puma'
require 'capistrano/nvm'

install_plugin Capistrano::Puma
install_plugin Capistrano::Puma::Systemd  # if using systemd

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
