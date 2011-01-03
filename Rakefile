# -*- coding: utf-8 -*-
require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "superfeedr-blather"
  gem.homepage = "http://github.com/kapoq/superfeedr-blather"
  gem.license = "MIT"
  gem.summary = %Q{superfeedr-blather implements a Superfeedr PubSub XMPP client in Ruby using the Blather gem.}
  gem.description = %Q{You get some patches for Blather and some classes that wrap the stuff you want from Superfeedr (entries, authors etc.). Under-the-hood, Blather uses EventMachine and Nokogiri so it’s fast and convenient. If you want to daemonize your client, daemon-kit comes ready with a blather template.}
  gem.email = "dave@kapoq.com"
  gem.authors = ["dave@kapoq.com"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
