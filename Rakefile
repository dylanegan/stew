begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "stew"
    gemspec.summary = "A good recipe for rabbits."
    gemspec.description = "Cook up some AMQP recipes."
    gemspec.email = "dylanegan@gmail.com"
    gemspec.homepage = "http://github.com/abcde/stew"
    gemspec.authors = ["Dylan Egan"]
    gemspec.files = %w(README.md)
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require File.dirname(__FILE__) + '/vendor/gems/environment'

desc 'Run exemplor'
task :exemplor do
  Dir["examples/**/*_exemplor.rb"].each { |example| puts `ruby -Ilib #{example}`; break unless $?.success? }
  unless $?.success?
    puts "An example failed. Please fix and retry."
  end
end

desc "Run all examples by default"
task :default => :exemplor
