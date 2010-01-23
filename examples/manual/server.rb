require File.dirname(__FILE__) + '/../../vendor/gems/environment'
require File.dirname(__FILE__) + '/../../lib/stew'

server = stew do |rabbit|
  rabbit.direct :example, :queue => :example
  rabbit.queue :example do |info, payload|
    puts payload
  end

  rabbit.queue :useless do |info, payload|
    puts payload
  end
end

server.run
