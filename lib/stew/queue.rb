module Stew
  class Queue
    attr_reader :name
    attr_accessor :bindings

    def initialize(name, options = {}, &block)
      @name = name
      raise Stew::Error.new("need handler, kthxbi!") unless block_given?
      @handler = block
      @bindings = []
    end

    def handle(info, payload)
      puts "q:#{@name} -> incoming"
      @handler.call(info, payload)
    end
  end
end
