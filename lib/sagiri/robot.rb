require "ruboty"

module Sagiri
  class Robot < Ruboty::Robot
    class << self
      def handlers
        @handlers ||= []
      end
    end

    def initialize(options = {})
      super
      brain
      build_handlers
    end

    # @note Override {Ruboty::Robot#receive}
    # @return [String]
    def receive(attributes)
      message = Sagiri::Message.new(attributes.merge(robot: self))
      Sagiri::Manager.reset_messages
      unless handlers.inject(false) { |matched, handler| matched | handler.call(message) }
        handlers.each do |handler|
          handler.call(message, missing: true)
        end
      end
      Sagiri::Manager.messages.join("\n")
    end

    private

    def build_handlers
      if self.class.handlers.empty?
        Ruboty.handlers.each do |handler_class|
          self.class.handlers << handler_class.new(self)
        end
      end
    end
  end
end
