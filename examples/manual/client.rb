require File.dirname(__FILE__) + '/../../vendor/gems/environment'
require 'bunny'

bunny = Bunny.new
bunny.start

direct = bunny.exchange('example')
direct.publish('example payload')
