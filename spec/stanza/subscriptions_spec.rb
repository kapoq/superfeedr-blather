require 'spec_helper'

describe "list of resources/subscriptions" do
  let(:stanza) { @stanza ||= open(File.expand_path(File.dirname(__FILE__) + '/../fixtures/resource_list.xml')) }
  let(:node)   { @node   ||= Blather::XMPPNode.import(Nokogiri::XML.parse(stanza).root) }

  describe Blather::Stanza::PubSub::Subscriptions do
    it "finds subscriptions" do
      node.list.should have(2).items
    end
  end

  describe Blather::Stanza::Superfeedr::Subscription do
    let(:sub) { node.list.first }

    it "finds subscription state" do
      sub.subscription_state.should == "subscribed"
    end    
  end
end
