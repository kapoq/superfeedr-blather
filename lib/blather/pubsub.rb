# Adds superfeedr entry to PubSubItem

module Blather
  class Stanza
    class PubSubItem < XMPPNode
      def entry
        n = find("atom:entry", :atom => ATOM)
        Superfeedr::Entry.new(n) unless n.nil?
      end
    end
  end
end
