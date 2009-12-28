require 'rubygems'
require File.dirname(__FILE__) + '/../../lib/stew/server'

server = stew do |rabbit|
  rabbit.queue :rapidmango do |queue|
    queue.direct :eventlogs do |direct|
      direct.key "create"
    end

    queue.handler do |info, payload|
      puts "EVENTLOGS::CREATE - #{info.inspect} - #{payload.inspect}"
    end
  end

  rabbit.queue :alerts do |queue|
    queue.fanout :alerts
    queue.handler do |info, payload|
      puts "ALERTS FANOUT! - #{info.inspect} - #{payload.inspect}"
    end
  end
end
 
server.run
