require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

ATOM = "http://www.w3.org/2005/Atom"

module Blather
  class Stanza::PubSub::Event
    def items
      items_node.find('//ns:item', :ns => Blather::Stanza::PubSub.registered_ns).map do |i|
        PubSubItem.new(nil,nil,self.document).inherit i
      end
    end
    
    def status
      n = find("ns2:status", :ns => self.class.registered_ns, :ns2 => "http://superfeedr.com/xmpp-pubsub-ext")
      Stanza::Superfeedr::Status.new(n) if n
    end
  end

  class Stanza::PubSubItem
    def entry
      find("./atom:entry", :atom => ATOM).map { |n| Stanza::Superfeedr::Entry.new(n) }
    end
  end


    # link
    # category
    # point
    # author

    # entry[@xml:lang] : The language of the entry. It's either extracted or computed from the content (the longer t# he content, the more relevant).

    # entry[@published] : The publication date (iso8601) of the entry.
    # entry[@updated] : The last updated date (iso8601) of the entry.
    # entry[@content] : The content of the entry. Check the type attribute to determine the mime-type.
    # entry[@summary] (optional, unique) : The summary of the entry. Check the type attribute to determine the mime-type  

# status[@feed] : contains the URL of the feed.
    # status[@digest] : if sets to true; it indicates that the notification is a digest.
    # http[@code] : last HTTP status code, please see Status Code Definitions.
    # http : the content of that tag is a more explicit log message for your information.
    # next_fetch : the feed will be fetched at most before this time.
    # period : the polling frequency in seconds for this feed.
    # last_fetch : the last time at which we fetched the feed.

    # last_parse : the last time at which we parsed the feed. It happens that we fetch a feed and do not parse it as its content hasn't been modified.
    # last_maintenance_at : Each feed inside Superfeedr has a maintenance cycle that we use to detect stale feeds, or related feeds. We normally run maintenance at most every 24hour for each feed.
    # entries_count_since_last_maintenance (provided only upon notification) : The number of new entries in the feed since we last ran the maintenance script. This is a very good indicator of the verboseness of a feed. You may want to remove feeds that are too verbose.
    # title (provided only upon notification) : the feed title.

  class Stanza::Superfeedr; end
  
  class Stanza::Superfeedr::Entry
    def initialize(node)
      @node = node
    end
    
    # entry[@id] : the Unique ID of the entry. If the original entry doesn't have an ID.
    def id
      content_from("./atom:id", :atom => ATOM)
    end

    # entry[@title] : The title of the entry.
    def title
      content_from("./atom:title", :atom => ATOM)
    end

    def link
      @node.find_first("./atom:link/@href", :atom => ATOM)
    end

    def content_from(*args)
      n = @node.find_first(*args)
      n.text if n
    end
    
  end

  class Stanza::Superfeedr::Status
  end

  class Stanza::Superfeedr::Author
  end

  class Stanza::Superfeedr::Link
  end

  class Stanza::Superfeedr::Point
  end

  class Stanza::Superfeedr::Category
  end
end
