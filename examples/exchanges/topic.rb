require 'rubygems'
require File.dirname(__FILE__) + '/../../lib/stew/server'

server = stew do |rabbit|
  rabbit.exchanges do |exchange|
    exchange.topic :errors do
      queue :foo do
        key [:fatal, :info]
      end
      key :warning, :queue => :warning
    end
  end
end
