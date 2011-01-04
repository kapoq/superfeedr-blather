require File.expand_path(File.dirname(__FILE__)) + '/../lib/superfeedr-blather'
require 'blather/client'

# setup YOUR_SUPERFEEDR_USERNAME, YOUR_SUPERFEEDR_PASSWORD

DUMMY = "http://superfeedr.com/dummy.xml"

when_ready do
  Blather.logger.info "Connected..."

  # TODO: use callbacks instead of timed sequence
  
  EM.add_timer(1) {
    write_to_stream Blather::Stanza::PubSub::Subscriptions.new(:get, :id => "subman1", :from => jid, :to => "firehoser.superfeedr.com")
  }
  
  EM.add_timer(3) {
    Blather.logger.info "unsubscribing from dummy"
    write_to_stream Blather::Stanza::PubSub::Unsubscribe.new(:set, "firehoser.superfeedr.com", DUMMY, jid)
  }

  EM.add_timer(5) {
    write_to_stream Blather::Stanza::PubSub::Subscriptions.new(:get, :id => "subman1", :from => jid, :to => "firehoser.superfeedr.com")
  }

  EM.add_timer(7) {
    Blather.logger.info "re-subscribing to dummy"
    write_to_stream Blather::Stanza::PubSub::Subscribe.new(:set, "firehoser.superfeedr.com", DUMMY, jid)
  }
  
  EM.add_timer(9) {
    write_to_stream Blather::Stanza::PubSub::Subscriptions.new(:get, :id => "subman1", :from => jid, :to => "firehoser.superfeedr.com")
    EM.stop
  }
end

# Subscription requests receive a stanza with the subscription
# status. Helpful.
pubsub_subscription :node => DUMMY do |sub|
  Blather.logger.info "#{sub.node} is #{sub.subscription}"
end

# Unsubscription requests just receive iq reply...
iq :result?, :id => /^#{Blather::Stanza::PubSub::Unsubscribe::PREFIX}_/ do |iq|
  Blather.logger.info "Reply: unsubscription request for #{iq.id.split(/_/).last} received OK"
end

# ...but we can always check the list of subscriptions
pubsub_subscriptions do |subs|
  unless subs.subscribed.include?(DUMMY)
    Blather.logger.info "#{DUMMY} is unsubscribed"
  end  
end
