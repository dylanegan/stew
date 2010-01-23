require 'rubygems'
require 'bunny'

bunny = Bunny.new
bunny.start

direct = bunny.exchange('example')

direct.publish('example payload')
