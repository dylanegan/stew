require 'rubygems'
require 'bunny'
 
bunny = Bunny.new
bunny.start
 
alerts = bunny.exchange('alerts', :type => :fanout)
other_alerts = bunny.exchange('other_alerts', :type => :fanout)
errors = bunny.exchange('errors', :type => :topic)
other = bunny.exchange('other')
bar = bunny.exchange('bar', :type => :fanout)

loop do
  alerts.publish('alert success')
  other.publish("other success")
  other.publish('other failure', :key => 'foo')
  other_alerts.publish('alert failure')
  errors.publish('errors failure', :key => 'errors.fail')
  errors.publish('errors fatal success', :key => 'errors.fatal')
  errors.publish('errors info success', :key => 'errors.info')
  bar.publish('bar fanout success')
  sleep 5
end
