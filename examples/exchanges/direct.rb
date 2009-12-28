require File.dirname(__FILE__) + '/../helper'

eg.setup do
  @server = stew do |rabbit|
    rabbit.direct :exemplor, :queue => :example
  end
end

eg 'A direct exchange named examplor tied to queue example' do
  exchange = @server.exchanges[:direct][:exemplor]
  Check(exchange.name).is(:exemplor)
  Check(exchange.key).is(nil)
  Check(exchange.queue).is(:example)
end
