%w( topic fanout direct ).each { |file| require "stew/exchange/#{file}" }

module Stew
  class Queue
    attr_accessor :bindings
    attr_reader :mappings, :name
    def initialize(name, options = {}, &block)
      @bindings = []
      @mappings = []
      @name = name
      @options = options
      yield(self) if block_given?
    end

    def direct(name, options = {}, &block)
      @mappings << Exchange::Direct.new(name, options, &block)
    end
   
    def fanout(name, options = {})
      @mappings << Exchange::Fanout.new(name, options)
    end
   
    def topic(name, options = {}, &block)
      @mappings << Exchange::Topic.new(name, options, &block)
    end

    def handler(&block)
      @handler = block
    end
    
    def handle(info, payload)
      @handler.call(info, payload)
    end
  end
end
