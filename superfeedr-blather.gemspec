# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{superfeedr-blather}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["dave@kapoq.com"]
  s.date = %q{2011-01-03}
  s.description = %q{You get some patches for Blather and some classes that wrap the stuff you want from Superfeedr (entries, authors etc.). Under-the-hood, Blather uses EventMachine and Nokogiri so it’s fast and convenient. If you want to daemonize your client, daemon-kit comes ready with a blather template.}
  s.email = %q{dave@kapoq.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README",
    "README.rdoc"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "README",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "autotest/discover.rb",
    "examples/echo.rb",
    "examples/sub_unsub.rb",
    "examples/timer.rb",
    "lib/blather/event.rb",
    "lib/blather/namespaces.rb",
    "lib/blather/pubsub.rb",
    "lib/blather/subscriptions.rb",
    "lib/superfeedr-blather.rb",
    "lib/superfeedr/superfeedr.rb",
    "spec/fixtures/notification.xml",
    "spec/fixtures/resource_list.xml",
    "spec/fixtures/resources_list_request.xml",
    "spec/spec_helper.rb",
    "spec/stanza/notification_spec.rb",
    "spec/stanza/subscriptions_spec.rb",
    "superfeedr-blather.gemspec"
  ]
  s.homepage = %q{http://github.com/kapoq/superfeedr-blather}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{superfeedr-blather implements a Superfeedr PubSub XMPP client in Ruby using the Blather gem.}
  s.test_files = [
    "examples/echo.rb",
    "examples/sub_unsub.rb",
    "examples/timer.rb",
    "spec/spec_helper.rb",
    "spec/stanza/notification_spec.rb",
    "spec/stanza/subscriptions_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<blather>, ["~> 0.4.14"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_development_dependency(%q<yard>, ["~> 0.6.0"])
      s.add_runtime_dependency(%q<blather>, ["~> 0.4.14"])
    else
      s.add_dependency(%q<blather>, ["~> 0.4.14"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_dependency(%q<yard>, ["~> 0.6.0"])
      s.add_dependency(%q<blather>, ["~> 0.4.14"])
    end
  else
    s.add_dependency(%q<blather>, ["~> 0.4.14"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    s.add_dependency(%q<yard>, ["~> 0.6.0"])
    s.add_dependency(%q<blather>, ["~> 0.4.14"])
  end
end

