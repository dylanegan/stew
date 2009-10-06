module Stew
  module Exchange
    class Topic
      attr_reader :mappings
      def initialize(name, options = {}, &block)
        @mappings = []
        @name = name
        @options = options
        yield(self) if block_given?
      end

      def bind(queue)
        if @options[:bind]
          amq = MQ.new
          queue.bindings << amq.queue(queue.name).bind(amq.topic(@name), @options)
        end
      end

      def key(routing_key, options = {})
        @mappings << Topic.new(@name, options.merge(:key => routing_key, :bind => true))
      end
    end
  end
end
