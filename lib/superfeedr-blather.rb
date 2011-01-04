require 'rubygems'
require 'bundler/setup'

require 'blather'

%w(namespaces pubsub event subscriptions unsubscribe).each { |f|
  require File.join(File.expand_path(File.dirname(__FILE__)), "blather", f)
}

%w(superfeedr).each { |f|
  require File.join(File.expand_path(File.dirname(__FILE__)), "superfeedr", f)
}
