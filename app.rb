require "sinatra/base"
require "sinatra/reloader"
require "dotenv/load"

# Ruboty
require "ruboty"
require "ruboty/alias"
require "ruboty/cron"
require "ruboty/echo"
require "ruboty/redis"
require "ruboty/ruby"
require "ruboty/syoboi_calendar"
require "ruboty/talk"

require_relative "./lib/sagiri"

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  set :root, File.dirname(__FILE__)

  robot   = Sagiri::Robot.new
  manager = Sagiri::Manager.new(robot)

  manager.bots.each do |key, bot|
    post bot.endpoint do
      begin
        bot.on_post(request)
      rescue Sagiri::BadRequestError => exception
        error 400
      end
    end
  end

  error 400 do
    "Bad Request"
  end
end
