require File.dirname(__FILE__) + '/helper'

eg.setup do
  @server = stew do |rabbit|
    rabbit.queue :example do |info, payload, server|
      payload
    end
  end
end

eg "An example queue returns the payload" do
  result = @server.queues[:example].handle([], "payload")
  Check(result).is("payload")
end
