require File.dirname(__FILE__) + '/../lib/stew/server'

eg.setup do
  @server = stew do |rabbit|
    rabbit.queue :example do |info, payload|
      payload
    end
  end
end

eg "An example queue returns the payload" do
  @server.queues[:example].call([], "payload").is("payload")
end
