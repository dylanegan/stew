module Stew
  class Queue
    attr_reader :name
    attr_accessor :bindings

    def initialize(name, options = {}, &block)
      @name = name
      raise Stew::Error.new("need handler, kthxbi!") unless block_given?
      @handler = block
      @bindings = []
      @options = options
      @server = @options.delete(:server)
    end

    def handle(info, payload)
      @server.logger.info "q:#{@name} -> incoming"
      @handler.call(info, payload, @server)
    end
  end
end
