module Stew
  module Exchange
    class Base
      attr_reader :name, :queue

      def initialize(name, options = {}, &block)
        @name = name
        @options = options
        @queue = @options.delete(:queue)
        @server = @options.delete(:server)
      end

      def bind
        if queue = @server.queues[@queue]
          @server.logger.info "#{@queue} -> bind #{self.type[0..0]}:#{@name}"
          amq = MQ.new
          exchange = MQ.send(type, @name)
          queue.bindings << amq.queue(@queue).bind(exchange, @options)
        end
      end

      def type
        self.class.to_s.downcase.gsub(/^.*::/, '')
      end
    end
  end
end

%w( topic fanout direct ).each { |file| require "stew/exchange/#{file}" }
