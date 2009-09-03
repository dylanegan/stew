require 'rubygems'
require 'bunny'
 
bunny = Bunny.new
bunny.start
 
alerts = bunny.exchange('alerts', :type => :fanout)
other_alerts = bunny.exchange('other_alerts', :type => :fanout)
eventlogs = bunny.exchange('eventlogs', :type => :topic)

loop do
  alerts.publish('test')
  other_alerts.publish('test')
  eventlogs.publish(Time.now, :key => 'create')
  eventlogs.publish('whoo', :key => '1.get')
  eventlogs.publish({:text => 'test'}.to_yaml, :key => '34.update')
  sleep 5
end
