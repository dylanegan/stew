module Stew
  module Server
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

      def match(match)
        @matcher = match
        yield(self) if block_given?
        @matcher = nil
      end

      def key(name, options = {})
        @mappings << Key.new(name, [:topic, @name], @matcher)
      end
    end
  end
end
