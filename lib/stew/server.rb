require 'mq'

module Stew
  module Server
    class Base
      def initialize(options = {}, &block)
        @options = options 
        @queues = {}
        yield(self) if block_given?
      end
     
      def queue(name, options, &block)
        @queues[name] = Queue.new(name, options, &block)
      end
     
      def run
        AMQP.start(@options) do
          @queues.each do |name, queue|
            create_bindings(queue.mappings)
          end
        end
      end
     
      def create_bindings(mappings)
        mappings.each do |name, mapping|
         create_bindings(mapping.mappings) if mapping.is_a? Topic
         next if mapping.skip?
         mapping.bind(@queue)
        end
      end
    end
    module Utensils
      def stew(options = {}, &block)
        Stew::Server::Base.new(options, &block)
      end
    end
  end
end

include Stew::Server::Utensils

$:.unshift File.dirname(__FILE__) + '/../'

%w( queue topic fanout direct key ).each { |file| require "stew/server/#{file}" }
