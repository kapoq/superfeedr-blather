require File.expand_path(File.dirname(__FILE__)) + '/../lib/superfeedr-blather'
require 'blather/client'

setup YOUR_SUPERFEEDR_USERNAME, YOUR_SUPERFEEDR_PASSWORD

when_ready do
  Blather.logger.info "Connected..."
end

pubsub_event do |e|
  puts "\n<!--Incoming!-->\n\n"

  e.items.each do |i|
    entry = i.entry
    puts "Entry:"
    puts "  #{entry.id}"
    puts "  #{entry.link.href}"
    puts "  #{entry.title}"
    puts "  #{entry.content}"
  end
  
  puts "\n<--eof message-->"
end

