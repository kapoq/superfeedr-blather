require 'spec_helper'

MESSAGE   = open(File.expand_path(File.dirname(__FILE__) + '/../fixtures/message.xml'))
XMPP_NODE = Blather::XMPPNode.import(Nokogiri::XML.parse(MESSAGE).root)

describe Blather::Stanza::PubSub::Event do
  it "finds items" do
    XMPP_NODE.should have(2).items
  end

  it "finds status" do
    XMPP_NODE.status.should be_present
  end  
end

describe Blather::Stanza::PubSubItem do
  it "finds entries" do
    XMPP_NODE.items.map(&:entry).compact.should have(2).entries
  end
end

describe Blather::Stanza::Superfeedr::Entry do
  it "fails" do
    XMPP_NODE.should_not be_nil
  end  
end

describe Blather::Stanza::Superfeedr::Status do
end

describe Blather::Stanza::Superfeedr::Link do
end

describe Blather::Stanza::Superfeedr::Author do
end

describe Blather::Stanza::Superfeedr::Point do
end

describe Blather::Stanza::Superfeedr::Category do
end




