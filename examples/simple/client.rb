require 'rubygems'
require 'bunny'
 
bunny = Bunny.new
bunny.start
 
alerts = bunny.exchange('alerts', :type => :fanout)
other_alerts = bunny.exchange('other_alerts', :type => :fanout)
eventlogs = bunny.exchange('eventlogs')

loop do
  alerts.publish('need more food')
  eventlogs.publish("#{Time.now} received", :key => 'create')
  eventlogs.publish('not received', :key => '')
  other_alerts.publish('all full')
  sleep 5
end
