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
  let(:entry) { XMPP_NODE.items.first.entry }

  it "finds the id" do
    entry.id.should == "tag:superfeedr.com,2005:String/1291996755"
  end

  it "finds the title" do
    entry.title.should == "15:59:15"
  end  

  it "finds the date published" do
    entry.published_at.should == DateTime.parse("2010-12-10T15:59:15+00:00")
  end
  
  it "finds the date updated" do
    entry.updated_at.should == DateTime.parse("2010-12-10T15:59:15+00:00")
  end

  it "finds the mime-type of the content" do
    entry.mime_type.should == "text"
  end  
  
  it "finds the content" do
    entry.content.should == "Friday December 10 15:59:15 UTC 2010 Somebody wanted to know what time it was."
  end

  it "finds the summary" do
    entry.summary.should == "A short message from our sponsors"
  end

  it "finds the lanugage" do
    entry.lang.should == "en-US"
  end

  it "finds the link" do
    entry.link.should be_instance_of(Blather::Stanza::Superfeedr::Link)
  end
  
  it "finds points" do
    entry.points.should have(1).item
  end
  
  it "finds the categories" do
    entry.categories.should have(1).item
  end
  
  it "finds the authors" do
    entry.authors.should have(1).item
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




