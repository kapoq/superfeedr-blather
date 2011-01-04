module Blather
  class Stanza
    class PubSub
      class Unsubscribe < PubSub
        PREFIX = "unsub"
        
        # Patch to set the id of the unsubscription request so the reply can be cross-referenced (see examples/sub_unsub.rb)
        def self.new(type = :set, host = nil, node = nil, jid = nil, unsub_id = nil)
          new_node = super(type, host)
          new_node.node = node
          new_node.jid = jid
          new_node.id = unsub_id || "#{PREFIX}_#{node}"
          new_node
        end
      end
    end
  end
end
