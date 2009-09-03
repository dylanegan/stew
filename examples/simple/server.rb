require 'rubygems'
require File.dirname(__FILE__) + '/../../lib/stew/server'

server = Stew::Server::Base.new do
  queue :rapidmango, :skip => true do
    topic :eventlogs, :skip => true do
      key "create" do |info, payload|                         # mq.queue('rapidmango').bind(mq.topic('eventlogs'), :key => "create")
        puts "EVENTLOGS::CREATE - #{info.inspect} - #{payload.inspect}"
      end
      
      match "*" do
        key "get" do |info, payload|                          # mq.queue('rapidmango').bind(mq.topic('eventlogs'), :key => "*.get"))
          id = info.routing_key.scan(/(.*)\.get/).flatten.first
          puts "EVENTLOGS::GET for #{id}"
        end
      end

      key "*.update" do |info, payload|                       # mq.queue('rapidmango').bind(mq.topic('eventlogs'), :key => "*.update"))
        id = info.routing_key.scan(/(.*)\.update/).flatten.first
        puts "EVENTLOGS::UPDATE for #{id} with #{payload.inspect}"
      end
    end
 
    fanout :alerts do |info, payload|                         # mq.queue('rapidmango').bind(mq.fanout('alerts'))
      puts "ALERTS FANOUT!"
    end
 
    fanout :other_alerts do |info, payload|                   # mq.queue('rapidmango').bind(mq.fanout('other_alerts'))
      puts "is this broken?"
    end
  end
end
 
server.run
