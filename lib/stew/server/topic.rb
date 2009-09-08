module Stew
  module Server
    class Topic
      attr_reader :mappings
      def initialize(name, options = {}, &block)
        @name = name
        @options = options
        @mappings = {} 
        if @options.delete(:eval) == false
          @block = block
        else
          yield(self) if block_given?
        end
      end
     
      def skip?
        @options[:skip]
      end
     
      def bind(queue)
        amq = MQ.new
        amq.queue(queue).bind(amq.topic(@name), @options).subscribe do |info, msg|
          @block.call(info, msg)
        end
      end
     
      def match(match, &block)
        @matcher = match
        yield(self) if block_given?
        @matcher = nil
      end
     
      def key(name, &block)
        @mappings[name] = Key.new(name, [:topic, @name], @matcher, &block)
      end
    end
  end
end
