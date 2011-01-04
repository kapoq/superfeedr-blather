module Superfeedr
  MAX_SIMULTANEOUS_SUBSCRIPTION_REQUESTS = 30
  
  class Node
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
      ns ||= {:atom => ATOM, :geo => GEO, :sf => SF}      
      @node.xpath(name, ns)
    end
  end


  class Entry < Node
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
      Link.new(child) if child
    end
    
    def categories
      xpath(".//atom:category/@term").map { |c| c.text }
    end

    def authors
      xpath(".//atom:author").map { |child| Author.new(child) }
    end

    def points
      xpath(".//geo:point").map { |child| Point.new(child) }
    end
  end

  class Status < Node
    # title (provided only upon notification) : the feed title.
    def title
      content_from("sf:title")
    end    
    
    # http[@code] : last HTTP status code, please see Status Code Definitions.
    def http_code
      content_from("sf:http/@code")
    end
    
    # http : the content of that tag is a more explicit log message for your information.
    def http
      content_from("sf:http")
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
      integer_from("sf:period")
    end

    # next_fetch : the feed will be fetched at most before this time.
    def next_fetch
      datetime_from("sf:next_fetch")
    end
    
    # last_fetch : the last time at which we fetched the feed.
    def last_fetch
      datetime_from("sf:last_fetch")
    end
    
    # last_parse : the last time at which we parsed the feed. It happens that we fetch a feed and do not parse it as its content hasn't been modified.
    def last_parse
      datetime_from("sf:last_parse")
    end

    # last_maintenance_at : Each feed inside Node has a
    # maintenance cycle that we use to detect stale feeds, or related
    # feeds. We normally run maintenance at most every 24hour for each
    # feed.
    
    def last_maintenance_at
      datetime_from("sf:last_maintenance_at")
    end

    # entries_count_since_last_maintenance (provided only upon notification) : The number of new entries in the feed since we last ran the maintenance script. This is a very good indicator of the verboseness of a feed. You may want to remove feeds that are too verbose.
    def entries_count_since_last_maintenance
      integer_from("sf:entries_count_since_last_maintenance")
    end
  end

  class Author < Node
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

  class Link < Node    
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

  class Point < Node 
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
