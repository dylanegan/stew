require 'mq'

module Stew
  class Server
    attr_reader :exchanges, :queues

    def initialize(options = {}, &block)
      @exchanges = { :direct => {}, :fanout => {}, :topic => {} }
      @options = options 
      @queues = {} 
      yield(self) if block_given?
    end

    def direct(name, options = {})
      @exchanges[:direct][name] = Exchange::Direct.new(name, options)
    end

    def fanout(name, options = {})
      @exchanges[:fanout][name] = Exchange::Fanout.new(name, options)
    end
   
    def queue(name, options = {}, &block)
      @queues[name] = Queue.new(name, options, &block)
    end

    def topic(name, options = {})
      @exchanges[:topic][name] = Exchange::Topic.new(name, options)
    end
   
    def run
      AMQP.start(@options) do
        @queues.each do |queue|
          bindings_for_mappings(queue, queue.mappings)
          queue.bindings.last.subscribe do |info, payload|
            queue.handle(info, payload)
          end
        end
      end
    end

    private
      def bindings_for_mappings(queue, mappings)
        mappings.each do |mapping|
          bindings_for_mappings(queue, mapping.mappings) if mapping.respond_to?(:mappings) && mapping.mappings.any?
          mapping.bind(queue)
        end
      end
  end

  module Utensils
    def stew(options = {}, &block)
      Stew::Server.new(options, &block)
    end
  end
end

include Stew::Utensils

$:.unshift File.dirname(__FILE__) + '/../'

require 'stew/queue'
%w( topic fanout direct ).each { |file| require "stew/exchange/#{file}" }
