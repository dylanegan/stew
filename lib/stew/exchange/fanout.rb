module Stew
  module Exchange
    class Fanout
      attr_reader :name, :queue

      def initialize(name, options = {}, &block)
        @name = name
        @options = options
        @queue = @options.delete(:queue)
      end

      def bind
        amq = MQ.new
        amq.queue(@queue).bind(amq.topic(@name), @options)
      end
    end
  end
end
