require 'rubygems'
require 'mq'

AMQP.start(:host => 'localhost') do
  def log(*args)
    puts [Time.now, *args]
  end

  def errors(what, key)
    mq = MQ.new
    EM.add_periodic_timer(1) do
      log :publishing, what, key
      mq.direct('eventlogs').publish(what, :routing_key => key)
    end
  end

  def alert(what)
    mq = MQ.new
    EM.add_periodic_timer(5) do
      log :alerting, what
      mq.fanout('alerts').publish(what)
    end
  end

  def bind
    mq = MQ.new
    mq.queue('rapidmango').bind(mq.direct('eventlogs'), :key => 'create').subscribe do |info, payload|
      log "creating #{payload.inspect}", info.inspect
    end

    mq = MQ.new
    mq.queue('alerts').bind(mq.fanout('alerts')).subscribe do |info, payload|
      log "alerting #{payload.inspect}", info.inspect
    end
  end

  error('fatal', 'errors.fatal')
  error('warning', 'errors.warning')
  alert('food needed')
  bind
end
