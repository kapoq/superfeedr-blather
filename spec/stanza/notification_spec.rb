require 'spec_helper'

describe "notifications" do
  let(:message) { @message ||= open(File.expand_path(File.dirname(__FILE__) + '/../fixtures/notification.xml')) }
  let(:node)    { @node    ||= Blather::XMPPNode.import(Nokogiri::XML.parse(message).root) }
  
  describe Blather::Stanza::PubSub::Event do
    it "finds items" do
      node.should have(2).items
    end

    it "finds status" do
      node.status.should be_present
    end  
  end

  describe Blather::Stanza::PubSubItem do
    it "finds entries" do
      node.items.map(&:entry).compact.should have(2).entries
    end
  end

  describe Superfeedr::Entry do
    let(:entry) { node.items.first.entry }

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
      entry.link.should be_instance_of(Superfeedr::Link)
    end
    
    it "finds points" do
      entry.points.should have(1).item
    end
    
    it "finds the categories" do
      entry.categories.should =~ %w(tests)
    end
    
    it "finds the authors" do
      entry.authors.should have(1).item
    end
  end

  describe Superfeedr::Status do
    let(:status) { node.status }
    
    it "finds the title" do
      status.title.should == "The Dummy Time Feed"
    end

    it "finds the http status" do
      status.http_code.should == "200"
    end

    it "finds the http response stats" do
      status.http.should == "7462B in 2.441718s, 2/10 new entries"
    end

    it "finds the entries_count_since_last_maintenance" do
      status.entries_count_since_last_maintenance.should == 19
    end

    it "finds the period" do
      status.period.should == 450
    end

    it "finds the next fetch datetime" do
      status.next_fetch.should == DateTime.parse("2010-12-10T16:06:41Z")
    end  
  end

  describe Superfeedr::Link do
    let(:link) { node.items.first.entry.link }

    it "finds type" do
      link.type.should == "text/html"
    end
    
    it "finds title" do
      link.title.should == "15:59:15"
    end

    it "finds rel" do
      link.rel.should == "alternate"
    end

    it "finds href" do
      link.href.should == "http://superfeedr.com/?1291996755"
    end  
  end

  describe Superfeedr::Author do
    let(:author) { node.items.first.entry.authors.first }

    it "finds name" do
      author.name.should == "Superfeedr"
    end

    it "finds uri" do
      author.uri.should == "http://superfeedr.com/"
    end

    it "finds email" do
      author.email.should == "julien@superfeedr.com"
    end
  end

  describe Superfeedr::Point do
    let(:point) { node.items.first.entry.points.first }

    it "finds long/lat" do
      point.longtitude.should == "37.773721"
      point.latitude.should   == "-122.414957"
    end

    it "finds raw data" do
      point.raw.should == "37.773721,-122.414957"
    end  
  end

end
