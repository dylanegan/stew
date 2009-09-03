module Stew
  module Server
    class Fanout
      def initialize(name, options, &block)
        @block = block
        @name = name
        @options = options
      end
     
      def skip?
        @options[:skip]
      end
     
      def bind(queue)
        amq = MQ.new
        amq.queue(queue).bind(amq.fanout(@name), @options).subscribe do |info, msg|
          @block.call(info, msg)
        end
      end
    end
  end
end
