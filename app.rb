require 'sinatra/base'
require 'sinatra/reloader'
require 'dotenv/load'
require_relative "./lib/sagiri"

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  set :root, File.dirname(__FILE__)

  robot = nil
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
    'Bad Request'
  end
end
