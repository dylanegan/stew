module Stew
  module Server
    class Queue
      attr_accessor :bindings
      attr_reader :mappings, :name
      def initialize(name, options = {}, &block)
        @bindings = []
        @mappings = []
        @name = name
        @options = options
        yield(self) if block_given?
      end

      def direct(name, options = {}, &block)
        @mappings << Direct.new(name, options, &block)
      end
     
      def fanout(name, options = {})
        @mappings << Fanout.new(name, options)
      end
     
      def topic(name, options = {}, &block)
        @mappings << Topic.new(name, options, &block)
      end

      def handler(&block)
        @handler = block
      end
      
      def handle(info, payload)
        @handler.call(info, payload)
      end
    end
  end
end
