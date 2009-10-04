module Stew
  module Server
    class Fanout
      def initialize(name, options)
        @name = name
        @options = options
      end
 
      def bind(queue)
        amq = MQ.new
        queue.bindings << amq.queue(queue.name).bind(amq.fanout(@name), @options)
      end
    end
  end
end
