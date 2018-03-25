module Sagiri
  module Bot
    class Base
      DEFAULT_NAME = "sagiri".freeze

      class << self
        def inherited(child_class)
          Sagiri::Manager.bot_classes << child_class
        end
      end

      attr_reader :robot, :handlers

      def initialize(robot)
        @robot = robot
        @handlers = robot.class.handlers
      end

      def name
        ENV["RUBOTY_NAME"] || DEFAULT_NAME
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
