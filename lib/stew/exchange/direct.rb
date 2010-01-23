module Stew
  module Exchange
    class Direct
      attr_reader :name, :queue

      def initialize(name, options = {}, &block)
        @name = name
        @options = options
        @queue = @options.delete(:queue)
        @server = @options.delete(:server)
      end

      def bind
        if queue = @server.queues[@queue]
          amq = MQ.new
          puts "Binding queue #{@queue} to direct exchange #{@name}"
          queue.bindings << amq.queue(@queue).bind(amq.direct(@name), @options)
        end
      end

      def key
        @options[:key]
      end
    end
  end
end
