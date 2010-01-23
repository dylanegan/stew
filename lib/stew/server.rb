module Stew
  class Server
    attr_reader :exchanges, :logger, :queues

    def initialize(options = {}, &block)
      @exchanges = { :direct => {}, :fanout => {}, :topic => {} }
      @options = options 
      @queues = {} 
      initialize_logger
      yield(self) if block_given?
    end

    def initialize_logger
      @logger = Logger.new(@options[:log_device] || STDOUT)
      @logger.level = @options[:log_level] || Logger::INFO
      @logger.datetime_format = @options[:log_format] || "%Y-%m-%d %H:%M:%S"
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
      @logger.info "server -> rising"
      AMQP.start(@options) do
        @exchanges.each do |type, exchanges|
          exchanges.each do |name, exchange|
            exchange.bind
          end
        end
        @queues.each do |name, queue|
          if queue.bindings.empty?
            @logger.info "q:#{queue.name} -> zero bindings -> not subscribing"
            next
          end
          @logger.info "q:#{queue.name} -> subscribing"
          queue.bindings.last.subscribe do |info, payload|
            queue.handle(info, payload)
          end
        end
      end
    end
  end
end
