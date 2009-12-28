module Stew
  module Exchange
    class Direct
      attr_reader :name, :queue

      def initialize(name, options = {}, &block)
        @name = name
        @options = options
        @queue = @options.delete(:queue)
      end

      def bind
        amq = MQ.new
        amq.queue(@queue).bind(amq.direct(@name), @options)
      end

      def key
        @options[:key]
      end
    end
  end
end
