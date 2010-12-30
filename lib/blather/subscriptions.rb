module Blather
class Stanza
class PubSub

  # # PubSub Subscriptions Stanza
  #
  # [XEP-0060 Section 5.6 Retrieve Subscriptions](http://xmpp.org/extensions/xep-0060.html#entity-subscriptions)
  #
  # @handler :pubsub_subscriptions
  class Subscriptions < PubSub

    # Overrides the parent to ensure a subscriptions node is created
    # @private
    def self.new(type, opts = {})
      new_node      = super type, nil
      new_node.to   = opts.delete(:to) || opts.delete(:host)
      new_node.from = opts.delete(:from)
      new_node.id   = opts.delete(:id)
      new_node.pubsub.add_namespace_definition("superfeedr", "http://superfeedr.com/xmpp-pubsub-ext")
      new_node.subscriptions(opts.delete(:page) || 1)
      new_node
    end  

    # Overrides the parent to ensure the subscriptions node is destroyed
    # @private
    def inherit(node)
      subscriptions.remove
      super
    end

    # Get or create the actual subscriptions node
    #
    # @return [Blather::XMPPNode]
    def subscriptions(page = 1)
      aff = pubsub.find_first('subscriptions', self.class.registered_ns)
      unless aff
        aff = XMPPNode.new('subscriptions', self.document)
        aff["superfeedr:page"] = page.to_s
        aff["jid"] = self.from
        self.pubsub << aff
      end
      aff
    end

    def list
      subscriptions.find('//ns:subscription', :ns => self.class.registered_ns).map do |child|
        Stanza::Superfeedr::Subscription.new(child)
      end
    end
  end  # Subscriptions

end  # PubSub
end  # Stanza
end  # Blather
