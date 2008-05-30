# require ActiveSupport::CoreExtensions::String::Inflections

namespace :limber do
  require(File.join(RAILS_ROOT, 'config', 'environment'))
  

  desc "Generating Flex code from app/flex/#{ENV['app']}.rb into app/flex/com/#{ENV['app']}"   unless ENV['app'].nil?
  task :generate_flex do
    unless ENV.include?("app") && File.exists?("app/flex/#{ENV['app'].underscore}.rb")
      raise "usage: rake limber:compile app=[name of app/flex]"
    end
    app = ENV['app'].underscore
    require "app/flex/#{app}.rb"
    app.camelcase.constantize.new.generate_flex
  end

  desc "Compiling Flex code in app/flex/com/#{ENV['app']}/ to app/flex/#{ENV['app'].camelcase}.swf" unless ENV['app'].nil?
  task :compile => [:generate_flex] do
  
    unless ENV.include?("app") && File.exists?("app/flex/#{ENV['app'].underscore}.rb")
      raise "usage: rake limber:compile app=[name of app/flex]"
    end
    app = ENV['app'].underscore
    begin
      Dir.chdir('app/flex')
      system "mxmlc  -library-path+=lib/  #{app.camelcase}.mxml"
    ensure
      Dir.chdir('../..')
    end
  end

  desc "Installing Flex code app/flex/#{ENV['app'].camelcase}.swf in public" unless ENV['app'].nil?
  task :install => [:compile] do
  
    unless ENV.include?("app") && File.exists?("app/flex/#{ENV['app'].underscore}.rb")
      raise "usage: rake limber:install app=[name of app/flex]"
    end
    app = ENV['app'].underscore
    cp "app/flex/#{app.camelcase}.swf", "public/"
  end

end