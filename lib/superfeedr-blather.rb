# TODO: sort out class heirarchy!

# TODO: stripped
# TODO: chunks

require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

ATOM     = "http://www.w3.org/2005/Atom"
GEO      = "http://www.georss.org/georss"
PS_EVENT = "http://jabber.org/protocol/pubsub#event"
PS_EXT   = "http://superfeedr.com/xmpp-pubsub-ext"

module Blather
  class Stanza::PubSub::Event
    def items
      items_node.find('//ns:item', :ns => Blather::Stanza::PubSub.registered_ns).map do |i|
        PubSubItem.new(nil,nil,self.document).inherit i
      end
    end
    
    def status
      n = find("ps_event:event/ps_ext:status", :ps_event => PS_EVENT, :ps_ext => PS_EXT)
      Stanza::Superfeedr::Status.new(n) if n
    end
  end

  class Stanza::PubSubItem
    def entry
      n = find("./atom:entry", :atom => ATOM)
      Stanza::Superfeedr::Entry.new(n) unless n.nil?
    end
  end

  class Stanza::Superfeedr
    def initialize(node)
      @node = node
    end
    
    private
    
    def content_from(name, ns = nil)
      child = xpath(name, ns).first
      child.content if child
    end

    def datetime_from(name, ns = nil)
      datetime = content_from(name, ns)
      DateTime.parse(datetime) if datetime
    end

    def integer_from(name, ns = nil)
      int = content_from(name, ns)
      int.to_i if int
    end

    def xpath(name, ns = nil)
      ns ||= {:atom => ATOM, :geo => GEO, :ps_ext => PS_EXT}      
      @node.xpath(name, ns)
    end    
  end
  
  class Stanza::Superfeedr::Entry < Stanza::Superfeedr
    # entry[@id] : the Unique ID of the entry. If the original entry doesn't have an ID.
    def id
      content_from("atom:id")
    end

    # entry[@title] : The title of the entry.
    def title
      content_from("atom:title")
    end

    # entry[@published] : The publication date (iso8601) of the entry.
    def published_at
      datetime_from("atom:published")
    end    

    # entry[@updated] : The last updated date (iso8601) of the entry.
    def updated_at
      datetime_from("atom:updated")
    end
        
    # entry[@content] : The content of the entry. Check the type attribute to determine the mime-type.
    def content
      content_from("atom:content")
    end

    def mime_type
      content_from("atom:content/@type")
    end    

    # entry[@summary] (optional, unique) : The summary of the entry. Check the type attribute to determine the mime-type  
    def summary
      content_from("atom:summary")
    end

    # entry[@xml:lang] : The language of the entry. It's either extracted or computed from the content (the longer t# he content, the more relevant).
    def lang
      content_from("@lang")
    end

    def link
      child = xpath("atom:link")
      Stanza::Superfeedr::Link.new(child) if child
    end
    
    def categories
      xpath(".//atom:category/@term").map { |c| c.text }
    end

    def authors
      xpath(".//atom:author").map { |child| Stanza::Superfeedr::Author.new(child) }
    end

    def points
      xpath(".//geo:point").map { |child| Stanza::Superfeedr::Point.new(child) }
    end
  end
  
  class Stanza::Superfeedr::Status < Stanza::Superfeedr
    # title (provided only upon notification) : the feed title.
    def title
      content_from("ps_ext:title")
    end    
    
    # http[@code] : last HTTP status code, please see Status Code Definitions.
    def http_code
      content_from("ps_ext:http/@code")
    end
    
    # http : the content of that tag is a more explicit log message for your information.
    def http
      content_from("ps_ext:http")
    end

    # status[@feed] : contains the URL of the feed
    def feed
      content_from("@feed")
    end

    # status[@digest] : if sets to true; it indicates that the
    # notification is a digest.
    def digest?
      !!content_from("@digest")
    end    

    # period : the polling frequency in seconds for this feed.
    def period
      integer_from("ps_ext:period")
    end

    # next_fetch : the feed will be fetched at most before this time.
    def next_fetch
      datetime_from("ps_ext:next_fetch")
    end
    
    # last_fetch : the last time at which we fetched the feed.
    def last_fetch
      datetime_from("ps_ext:last_fetch")
    end
    
    # last_parse : the last time at which we parsed the feed. It happens that we fetch a feed and do not parse it as its content hasn't been modified.
    def last_parse
      datetime_from("ps_ext:last_parse")
    end

    # last_maintenance_at : Each feed inside Superfeedr has a
    # maintenance cycle that we use to detect stale feeds, or related
    # feeds. We normally run maintenance at most every 24hour for each
    # feed.
    
    def last_maintenance_at
      datetime_from("ps_ext:last_maintenance_at")
    end

    # entries_count_since_last_maintenance (provided only upon notification) : The number of new entries in the feed since we last ran the maintenance script. This is a very good indicator of the verboseness of a feed. You may want to remove feeds that are too verbose.
    def entries_count_since_last_maintenance
      integer_from("ps_ext:entries_count_since_last_maintenance")
    end
  end

  class Stanza::Superfeedr::Author < Stanza::Superfeedr
    def name
      content_from("atom:name")
    end

    def uri
      content_from("atom:uri")
    end

    def email
      content_from("atom:email")
    end
  end

  class Stanza::Superfeedr::Link < Stanza::Superfeedr    
    def type
      content_from("@type")
    end

    def title
      content_from("@title")
    end

    def rel
      content_from("@rel")
    end

    def href
      content_from("@href")
    end    
  end

  class Stanza::Superfeedr::Point < Stanza::Superfeedr 
    def raw
      content_from(".")
    end

    def longtitude
      point.first
    end

    def latitude
      point.last
    end

    def point
      @point ||= (raw || []) && raw.split(",")
    end    
  end
end
