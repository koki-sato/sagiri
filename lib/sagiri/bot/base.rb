module Sagiri
  module Bot
    class Base
      class << self
        def inherited(child_class)
          Sagiri::Manager.bot_classes << child_class
        end
      end

      attr_reader :robot

      def initialize(robot)
        @robot = robot
      end

      def endpoint
        fail NotImplementedError
      end

      def bad_request
        raise BadRequestError
      end
    end
  end
end
