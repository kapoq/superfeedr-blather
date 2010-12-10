# # Patch to use correct items namespace 
# module Blather
#   class Stanza::PubSub::Event
#     def items
#       puts "here"
#       items_node.find('//ns:item', :ns => Blather::Stanza::PubSub.registered_ns).map do |i|
#         PubSubItem.new(nil,nil,self.document).inherit i
#       end
#     end      
#   end

#   class Stanza::PubSubItem
#     def entries
#       puts "there"
#       find("//atom:entry").map { |n| Superfeedr::Entry.new(n) }
#     end

#     def status
#       find("//atom:status").map { |n| Superfeedr::Status.new(n) }
#     end
#   end
# end
