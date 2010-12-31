require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

%w(namespaces pubsub event subscriptions).each { |f| require File.join(File.expand_path(File.dirname(__FILE__)), "blather", f) }
%w(superfeedr).each { |f| require File.join(File.expand_path(File.dirname(__FILE__)), "superfeedr", f) }
