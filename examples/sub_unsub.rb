require File.expand_path(File.dirname(__FILE__)) + '/../lib/superfeedr-blather'
require 'blather/client'

setup YOUR_SUPERFEEDR_USERNAME, YOUR_SUPERFEEDR_PASSWORD

when_ready do
  Blather.logger.info "Connected..."

  # TODO: use callbacks instead of timed sequence
  
  EM.add_timer(1) {
    write_to_stream Blather::Stanza::PubSub::Subscriptions.new(:get, :id => "subman1", :from => jid, :to => "firehoser.superfeedr.com")
  }
  
  EM.add_timer(4) {
    Blather.logger.info "unsubscribing from dummy"
    write_to_stream Blather::Stanza::PubSub::Unsubscribe.new :set, "firehoser.superfeedr.com", "http://superfeedr.com/dummy.xml", jid
  }

  EM.add_timer(7) {
    write_to_stream Blather::Stanza::PubSub::Subscriptions.new(:get, :id => "subman1", :from => jid, :to => "firehoser.superfeedr.com")
  }

  EM.add_timer(10) {
    Blather.logger.info "re-subscribing to dummy"
    write_to_stream Blather::Stanza::PubSub::Subscribe.new :set, "firehoser.superfeedr.com", "http://superfeedr.com/dummy.xml", jid
  }
  
  EM.add_timer(13) {
    write_to_stream Blather::Stanza::PubSub::Subscriptions.new(:get, :id => "subman1", :from => jid, :to => "firehoser.superfeedr.com")
  }
end

pubsub_subscriptions do |subs|
  if subs.list.detect { |sub| sub.node_url =~ /dummy\.xml/ }
    Blather.logger.info "subscribed to dummy.xml"
  else
    Blather.logger.info "not subscribed to dummy.xml"
  end  
end

