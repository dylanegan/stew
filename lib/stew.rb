require 'logger'
require 'mq'

$:.unshift File.dirname(__FILE__)

require 'stew/exchange'
require 'stew/queue'
require 'stew/server'
require 'stew/utensils'

include Stew::Utensils
