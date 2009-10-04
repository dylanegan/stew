module Stew
  module Server
    class Key
      def initialize(name, exchange, matcher)
        @matcher = matcher
        @name = name
        @exchange = exchange
      end

      def bind(queue)
        amq = MQ.new
        exchange = MQ::Exchange.new(MQ.new, @exchange[0], @exchange[1])
        queue.bindings << amq.queue(queue.name).bind(exchange, :key => key)
      end

      def key
        @matcher ? "#{@matcher}.#{@name}" : @name
      end
    end
  end
end
