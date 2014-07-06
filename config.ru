# config.ru
#set :environment, :production

require "./app"
run Sinatra::Application
