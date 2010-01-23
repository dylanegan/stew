require File.dirname(__FILE__) + '/../helper'

eg.setup do
  @server = stew do |rabbit|
    rabbit.topic :exemplor, :key => :example, :queue => :example
  end
end

eg 'A topic exchange for examplor with key example tied to queue example' do
  exchange = @server.exchanges[:topic][:exemplor]  
  Check(exchange.name).is(:exemplor)
  Check(exchange.key).is(:example)
  Check(exchange.queue).is(:example)
end
