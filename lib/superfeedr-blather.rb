# TODO: apply patches to blather
# * loading filename conflicts using bundler
# * multiple namespaces

# TODO: copy ActiveRecord casting

# TODO: notifications extensions:
# * stripped
# * chunks
# Are these still used by Superfeedr? No mention of them in the schema docs

require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

%w(namespaces pubsub event subscriptions).each { |f| require File.join(File.expand_path(File.dirname(__FILE__)), "blather", f) }
%w(superfeedr).each { |f| require File.join(File.expand_path(File.dirname(__FILE__)), "superfeedr", f) }
