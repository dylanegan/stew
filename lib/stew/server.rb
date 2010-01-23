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
      puts "server -> rising"
      AMQP.start(@options) do
        @exchanges.each do |type, exchanges|
          exchanges.each do |name, exchange|
            exchange.bind
          end
        end
        @queues.each do |name, queue|
          if queue.bindings.empty?
            puts "q:#{queue.name} -> zero bindings -> not subscribing"
            next
          end
          puts "q:#{queue.name} -> subscribing"
          queue.bindings.last.subscribe do |info, payload|
            queue.handle(info, payload)
          end
        end
      end
    end
  end
end
