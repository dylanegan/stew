require 'rubygems'
require File.dirname(__FILE__) + '/../../lib/stew/server'

server = stew do |stew|
  stew.queue :rapidmango do |queue|
    queue.direct :eventlogs do |direct|
      direct.key "create"
    end

    queue.handler do |info, payload|
      puts "EVENTLOGS::CREATE - #{info.inspect} - #{payload.inspect}"
    end
  end

  stew.queue :alerts do |queue|
    queue.fanout :alerts
    queue.handler do |info, payload|
      puts "ALERTS FANOUT! - #{info.inspect} - #{payload.inspect}"
    end
  end
end
 
server.run
