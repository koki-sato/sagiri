require_relative "./sagiri/manager"
require_relative "./sagiri/message"
require_relative "./sagiri/robot"
require_relative "./sagiri/bot/base"
require_relative "./sagiri/bot/line"

module Sagiri
  class BadRequestError < StandardError
  end
end
