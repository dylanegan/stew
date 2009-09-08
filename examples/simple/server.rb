require 'rubygems'
require File.dirname(__FILE__) + '/../../lib/stew/server'

server = stew do |stew|
  stew.queue :rapidmango, :skip => true do |queue|
    queue.topic :eventlogs, :skip => true do |topic|
      topic.key "create" do |info, payload|                         # mq.queue('rapidmango').bind(mq.topic('eventlogs'), :key => "create")
        puts "EVENTLOGS::CREATE - #{info.inspect} - #{payload.inspect}"
      end
      
      topic.match "*" do |match|
        match.key "get" do |info, payload|                          # mq.queue('rapidmango').bind(mq.topic('eventlogs'), :key => "*.get"))
          id = info.routing_key.scan(/(.*)\.get/).flatten.first
          puts "EVENTLOGS::GET for #{id}"
        end
      end

      topic.key "*.update" do |info, payload|                       # mq.queue('rapidmango').bind(mq.topic('eventlogs'), :key => "*.update"))
        id = info.routing_key.scan(/(.*)\.update/).flatten.first
        puts "EVENTLOGS::UPDATE for #{id} with #{payload.inspect}"
      end
    end
 
    queue.fanout :alerts do |info, payload|                         # mq.queue('rapidmango').bind(mq.fanout('alerts'))
      puts "ALERTS FANOUT!"
    end
 
    queue.fanout :other_alerts do |info, payload|                   # mq.queue('rapidmango').bind(mq.fanout('other_alerts'))
      puts "is this broken?"
    end
  end
end
 
server.run
