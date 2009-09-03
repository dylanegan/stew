module Stew
  module Server
    class Queue
      attr_reader :mappings
      def initialize(name, options = {}, &block)
        @mappings = {}
        @name = name
        @options = options
        instance_eval &block if block_given?
      end

      def direct(name, options = {}, &block)
        @mappings[name] = Direct.new(name, options, &block)
      end
     
      def fanout(name, options = {}, &block)
        @mappings[name] = Fanout.new(name, options, &block)
      end
     
      def topic(name, options = {}, &block)
        @mappings[name] = Topic.new(name, options, &block)
      end
    end
  end
end
