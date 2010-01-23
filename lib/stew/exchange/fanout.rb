module Stew
  module Exchange
    class Fanout
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
          puts "Binding queue #{@queue} to fanout exchange #{@name}"
          queue.bindings << amq.queue(@queue).bind(amq.topic(@name), @options)
        end
      end
    end
  end
end
