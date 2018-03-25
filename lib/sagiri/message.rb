require "ruboty"

module Sagiri
  class Message < Ruboty::Message
    # @note Override {Ruboty::Message#reply}
    def reply(body, options = {})
      Sagiri::Manager.messages << body
    end
  end
end
