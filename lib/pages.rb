# Hepler to load all page classes at runtime

Dir["#{File.dirname(__FILE__)}/pages/*_page.rb"].each {|r| load r }
Dir["#{File.dirname(__FILE__)}/pages/*/*_page.rb"].each {|r| load r }
Dir["#{File.dirname(__FILE__)}/pages/*/*/*_page.rb"].each {|r| load r }
