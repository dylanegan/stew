module Stew
  class Queue
    attr_reader :name
    attr_accessor :bindings

    def initialize(name, options = {}, &block)
      @name = name
      raise "Please provide a handler" unless block_given?
      @handler = block
      @bindings = []
    end

    def handle(info, payload)
      puts "Handling payload for queue #{@name}"
      @handler.call(info, payload)
    end
  end
end
