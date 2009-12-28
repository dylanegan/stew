require 'rubygems'
require File.dirname(__FILE__) + '/../../lib/stew/server'

server = stew do |rabbit|
  rabbit.exchanges do |exchange|
    exchange.direct :other, :queue => [:bar, :foo]
  end
end
