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
      @exchanges[:direct][name] = Exchange::Direct.new(name, options.merge(:server => self))
    end

    def fanout(name, options = {})
      @exchanges[:fanout][name] = Exchange::Fanout.new(name, options.merge(:server => self))
    end
   
    def queue(name, options = {}, &block)
      @queues[name] = Queue.new(name, options.merge(:server => self), &block)
    end

    def topic(name, options = {})
      @exchanges[:topic][name] = Exchange::Topic.new(name, options.merge(:server => self))
    end
   
    def run
      puts "Starting up the server..."
      AMQP.start(@options) do
        @exchanges.each do |type, exchanges|
          exchanges.each do |name, exchange|
            exchange.bind
          end
        end
        @queues.each do |name, queue|
          next if queue.bindings.empty?
          puts "Subscribing to queue #{queue.name}"
          queue.bindings.last.subscribe do |info, payload|
            queue.handle(info, payload)
          end
        end
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
