module Stew
  class Queue
    attr_reader :name

    def initialize(name, options = {}, &block)
      @name = name
      raise "Please provide a handler" unless block_given?
      @handler = block
    end

    def handle(info, payload)
      @handler.call(info, payload)
    end
  end
end
