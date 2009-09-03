module Stew
  module Server
    class Direct
      def initialize(name, options, &block)
        @name = name
        @options = options
        @block = block
      end
     
      def skip?
        @options[:skip]
      end
     
      def bind(queue)
        amq = MQ.new
        amq.queue(queue).bind(amq.direct, @options).subscribe do |info, msg|
          @block.call(info, msg)
        end
      end
    end
  end
end
