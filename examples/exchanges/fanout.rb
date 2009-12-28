require 'rubygems'
require File.dirname(__FILE__) + '/../../lib/stew/server'

server = stew do |rabbit|
  rabbit.exchanges do |exchange|
    exchange.fanout :alerts, :queue => :example
    exchange.fanout :bar, :queue => :bar
  end
end
