# Monkey-patch to add status and fix items lookup

module Blather
  class Stanza
    class PubSub
      class Event < Message
        def items
          items_node.find('.//ps:item', :ps => PS).map do |i|
            PubSubItem.new(nil,nil,self.document).inherit i
          end
        end
        
        def status
          n = find("ps_event:event/sf:status", :ps_event => PS_EVENT, :sf => SF)
          Superfeedr::Status.new(n) if n
        end
      end
    end
  end
end
