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

require File.dirname(__FILE__) + '/tmp/vendor/environment'

require 'spec/rake/spectask'

Spec::Rake::SpecTask.new(:spec) do |t|
  desc "Run all specs in spec directory"
  t.spec_opts = ['--options', "\"spec/spec.opts\""]
  t.spec_files = FileList['spec/**/*_spec.rb']
end
