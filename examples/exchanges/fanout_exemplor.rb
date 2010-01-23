require File.dirname(__FILE__) + '/../helper'

eg.setup do
  @server = stew do |rabbit|
    rabbit.fanout :exemplor, :queue => :example
  end
end

eg 'A fanout exchange named examplor tied to queue example' do
  exchange = @server.exchanges[:fanout][:exemplor]  
  Check(exchange.name).is(:exemplor)
  Check(exchange.queue).is(:example)
end
