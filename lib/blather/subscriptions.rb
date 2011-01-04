# Monkey-patch to add superfeedr namespace and jid/page attributes

module Blather
  class Stanza
    class PubSub      
      class Subscriptions
        def self.new(type, opts = {})
          new_node      = super type, nil
          new_node.to   = opts.delete(:to) || opts.delete(:host)
          new_node.from = opts.delete(:from)
          new_node.id   = opts.delete(:id)
          new_node.pubsub.add_namespace_definition("sf", SF)
          new_node.subscriptions(opts.delete(:page) || 1)
          new_node
        end  

        def subscriptions(page = 1)
          aff = pubsub.find_first('subscriptions', self.class.registered_ns)
          unless aff
            aff = XMPPNode.new('subscriptions', self.document)
            aff["sf:page"] = page.to_s
            aff["jid"] = self.from
            self.pubsub << aff
          end
          aff
        end

        def subscribed
          (list[:subscribed] || []).map { |h| h[:node] }
        end        
      end
    end
  end
end
