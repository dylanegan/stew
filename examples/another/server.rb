require 'rubygems'
require File.dirname(__FILE__) + '/../../lib/stew/server'

server = stew do |rabbit|
  rabbit.exchanges do |exchange|
    exchange.fanout :alerts, :queue => :example
    exchange.fanout :bar, :queue => :bar
    exchange.direct :other, :queue => [:bar, :foo]
    exchange.topic :errors do
      for_queue :foo do
        key [:fatal, :info]
      end
      key :warning, :queue => :warning
    end
  end

  rabbit.queue :example do |info, payload|
    puts "alert: #{payload}"
  end

  rabbit.queue :bar do |info, payload|
    puts "bar or other: #{payload}"
  end

  rabbit.queue :foo do |info, payload|
    puts "error or other: #{payload}"
  end

  rabbit.queue :warning do |info, payload|
    puts "warning: #{payload}"
  end
end

server.run
