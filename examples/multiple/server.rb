require 'rubygems'
require File.dirname(__FILE__) + '/../../lib/stew/server'

server = stew do |rabbit|
  rabbit.queue :example do |queue|
    queue.fanout :alerts
    queue.handler do |info, payload|
      puts "alert: #{payload}"
    end
  end

  rabbit.queue :bar do |queue|
    queue.fanout :bar
    queue.direct :other, :bind => true
    queue.handler do |info, payload|
      puts "bar: #{payload}"
    end
  end

  rabbit.queue :foo do |queue|
    queue.topic :errors do |topic|
      topic.key "errors.fatal"
      topic.key "errors.info"
    end
    queue.direct :other, :bind => true

    queue.handler do |info, payload|
      puts "error or other: #{payload}"
    end
  end
end

server.run
