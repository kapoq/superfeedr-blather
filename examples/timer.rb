require File.expand_path(File.dirname(__FILE__)) + '/../lib/superfeedr-blather'
require 'blather/client'

setup YOUR_SUPERFEEDR_USERNAME, YOUR_SUPERFEEDR_PASSWORD

when_ready do
  Blather.logger.info"Connected..."

  EM.add_periodic_timer(3) {
    Blather.logger.info "fetching subs"
    write_to_stream Blather::Stanza::PubSub::Subscriptions.new(:get, :id => "subman1", :from => jid, :to => "firehoser.superfeedr.com")
  }
end

pubsub_subscriptions do |subs|
  puts "\n<!--Incoming!-->\n\n"
  subs.list.each { |sub| puts "#{sub.node_url} is #{sub.subscription_state}" }
  puts "\n<--eof message-->"
end
