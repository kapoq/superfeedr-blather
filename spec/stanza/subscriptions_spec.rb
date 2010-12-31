require 'spec_helper'

describe "list of resources/subscriptions" do
  let(:stanza) { @stanza ||= open(File.expand_path(File.dirname(__FILE__) + '/../fixtures/resource_list.xml')) }
  let(:node)   { @node   ||= Blather::XMPPNode.import(Nokogiri::XML.parse(stanza).root) }

  describe Blather::Stanza::PubSub::Subscriptions do
    it "finds subscriptions" do
      node.list.should have(2).items
    end
  end

  describe Superfeedr::Subscription do
    let(:sub) { node.list.first }

    it "finds subscription state" do
      sub.subscription_state.should == "subscribed"
    end    
  end
end

describe "requesting list of resources/subscriptions" do
  describe Blather::Stanza::PubSub::Subscriptions do
    let(:node) { @node ||= Blather::Stanza::PubSub::Subscriptions.new(:get, :id => "subman1", :from => "test@superfeedr.com", :to => "firehoser.superfeedr.com") }
    
    it "includes correct to, from, and id attributes in the <iq> node" do
      node["from"].should == "test@superfeedr.com"
      node["to"].should   == "firehoser.superfeedr.com"
      node["id"].should   == "subman1"
    end
    
    it "includes superfeedr namespace in the <pubsub> node" do
      pubsub_node = node.find_first(".//ns:subscriptions", :ns => Blather::Stanza::PubSub.registered_ns)
      pubsub_node.namespaces["xmlns:sf"].should == "http://superfeedr.com/xmpp-pubsub-ext"
    end
    
    it "includes page and jid in the <subscriptions> node" do
      subscriptions_node = node.find_first(".//ns:subscriptions", :ns => Blather::Stanza::PubSub.registered_ns)
      subscriptions_node["jid"].should == "test@superfeedr.com"
      subscriptions_node["sf:page"].should == "1"
    end    
  end  
end

