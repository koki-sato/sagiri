module Sagiri
  class Manager
    def self.bot_classes
      @bot_classes ||= []
    end

    def initialize(robot)
      @robot = robot
      self.class.bot_classes.each do |bot_class|
        key = bot_class.name.split('::').last.downcase.to_sym
        bot = bot_class.new(robot)
        bots[key] = bot
      end
    end

    def bots
      @bots ||= {}
    end
  end
end
