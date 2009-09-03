module Stew
  module Server
    class Key
      def initialize(name, exchange, matcher, &block)
        @block = block
        @matcher = matcher
        @name = name
        @exchange = exchange
      end
     
      def skip?
        false
      end
     
      def bind(queue)
        amq = MQ.new
        exchange = MQ::Exchange.new(MQ.new, @exchange[0], @exchange[1])
        amq.queue(queue).bind(exchange, :key => key).subscribe do |info, msg|
          @block.call(info, msg)
        end
      end
     
      def key
        @matcher ? "#{@matcher}.#{@name}" : @name
      end
    end
  end
end
