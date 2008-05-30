require 'limber'
require 'limber/core_ext/string'
require 'limber/core_ext/active_record_base'


class FlexApplicationGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.directory("app/flex")
  	  m.template("flex_application.rb", "app/flex/#{file_name}.rb", :collision => :skip)
  	  m.directory("app/flex/com")
  	  m.directory("app/flex/com/#{file_name}")
  	  m.directory("app/flex/com/#{file_name}/assets")
  	  m.file("logo.png", "app/flex/com/#{file_name}/assets/logo.png")
  	  m.directory("app/flex/com/#{file_name}/business")
  	  m.template("com/business/SessionDelegate.as", "app/flex/com/#{file_name}/business/SessionDelegate.as")
  	  m.directory("app/flex/com/#{file_name}/command")
  	  m.template("com/command/CreateSessionCommand.as", "app/flex/com/#{file_name}/command/CreateSessionCommand.as")
  	  m.template("com/command/DestroySessionCommand.as", "app/flex/com/#{file_name}/command/DestroySessionCommand.as")
      m.directory("app/flex/com/#{file_name}/components")
      m.directory("app/flex/com/#{file_name}/control")
  	  m.directory("app/flex/com/#{file_name}/model")
  	  m.directory("app/flex/com/#{file_name}/util")
  	  m.template("utils/CairngormUtils.as", "app/flex/com/#{file_name}/util/CairngormUtils.as")
  	  m.template("utils/DebugMessage.as", "app/flex/com/#{file_name}/util/DebugMessage.as")
  	  m.template("utils/ServiceUtils.as", "app/flex/com/#{file_name}/util/ServiceUtils.as")
  	  m.template("utils/XMLUtils.as", "app/flex/com/#{file_name}/util/XMLUtils.as")
  	  m.directory("app/flex/com/#{file_name}/validators")
  	  m.template("com/validators/ServerErrors.as", "app/flex/com/#{file_name}/validators/ServerErrors.as")
  	  m.template("com/validators/ServerErrorValidator.as", "app/flex/com/#{file_name}/validators/ServerErrorValidator.as")
  	  m.directory("app/flex/lib")
  	  m.file("lib/Cairngorm.swc", "app/flex/lib/Cairngorm.swc")
  	  m.template("public/Application.html", "public/#{file_name.camelcase}.html")
  	  m.directory("public/javascripts")
  	  m.directory("public/javascripts/flex")
  	  m.file("public/AC_OETags.js", "public/javascripts/flex/AC_OETags.js")
  	  
  	  # Rails Generators apparently call all further parameters "actions"
  	  # Even the mailer generator suffers with this.
  	  model_classes = {}
  	  read_only_models = []
  	  actions.each do |model_name|

    	  model_klass = model_name.camelcase.constantize
    	  model_is_read_only = !model_klass.columns.collect(&:name).include?("id")
    	  read_only_models << model_name if model_is_read_only

    	  m.template( "com/business/ModelDelegate.as",
    	              "app/flex/com/#{file_name}/business/#{model_name.camelcase}Delegate.as", 
    	              :assigns => { :model_name => model_name.camelcase, :model_label => model_name.underscore.downcase,
    	                            :model_is_read_only => model_is_read_only})

    	  m.template( "com/command/ListCommand.as", 
    	              "app/flex/com/#{file_name}/command/List#{model_name.pluralize.camelcase}Command.as", 
    	              :assigns => { :model_name => model_name })
    	  unless model_is_read_only
      	  m.template( "com/command/CreateCommand.as", 
      	              "app/flex/com/#{file_name}/command/Create#{model_name.camelcase}Command.as", 
      	              :assigns => { :model_name => model_name, :model_klass => model_klass })
      	  m.template( "com/command/DestroyCommand.as",
      	              "app/flex/com/#{file_name}/command/Destroy#{model_name.camelcase}Command.as", 
      	              :assigns => { :model_name => model_name, :model_klass => model_klass })
      	  m.template( "com/command/UpdateCommand.as",
      	              "app/flex/com/#{file_name}/command/Update#{model_name.camelcase}Command.as", 
      	              :assigns => { :model_name => model_name, :model_klass => model_klass })
    	  end
    	              
    	  model_attributes = model_klass.columns + (model_klass.respond_to?(:methods_to_serialize) ? model_klass.methods_to_serialize : [])
    	  model_attributes.delete_if{|a| model_klass.methods_to_hide.collect(&:name).include?(a.name)} if model_klass.respond_to?(:methods_to_hide)
    	  model_belongs_to_associations = [] #model_klass.reflect_on_all_associations.select {|a| a.macro.eql?(:belongs_to)}
    	  model_has_many_associations = [] # model_klass.reflect_on_all_associations.select {|a| a.macro.eql?(:has_many)}
    	  model_has_one_associations = [] #model_klass.reflect_on_all_associations.select {|a| a.macro.eql?(:has_one)}
    	  
    	  model_meta_data = { :model_name => model_name.camelcase, 
                            :model_label => model_name.underscore.downcase,
                            :model_klass => model_klass,
                            :model_attributes => model_attributes,
                            :model_belongs_to_associations => model_belongs_to_associations,
                            :model_has_one_associations => model_has_one_associations,
                            :model_has_many_associations => model_has_many_associations,
                            :model_is_read_only => model_is_read_only }
    	  model_classes[model_name] = model_meta_data
    	  
    	  m.template( "com/model/Model.as",
    	              "app/flex/com/#{file_name}/model/#{model_name.camelcase}.as", 
    	              :assigns => model_meta_data )
  	  end
  	  
  	  # We generalize the distinction in the example application between
  	  # "lookup_models" (:has_many) and "primary_models." (:belongs_to) 
  	  # This part of the concept will have to be expanded upon to support more 
  	  # general applications.  If the model :has_many anything, it is assumed to be a look_up.
  	  
  	  has_many_models = model_classes.values.select {|mc| mc[:model_has_many_associations].size > 0 }
  	  belongs_to_models = model_classes.values.select {|mc| mc[:model_has_many_associations].size == 0 }
  	  
      m.template( "com/model/ApplicationModelLocator.as",
                  "app/flex/com/#{file_name}/model/#{class_name}ModelLocator.as",
                  :assigns => { :model_names => actions, 
                                :model_classes => model_classes,
                                :has_many_models => has_many_models, 
                                :belongs_to_models => belongs_to_models, 
                                :read_only_models => read_only_models })
                                
      
  	  m.directory("app/flex/com/#{file_name}/control")
  	  m.template( "com/control/ApplicationController.as",
  	              "app/flex/com/#{file_name}/control/#{class_name}Controller.as", 
  	              :assigns => { :model_names => actions, :read_only_models => read_only_models })
  	  m.template( "com/control/EventNames.as",
  	              "app/flex/com/#{file_name}/control/EventNames.as", 
  	              :assigns => { :model_names => actions, :read_only_models => read_only_models })

    end
  end
end


class ASType
  MAPPINGS = {
    'Fixnum' => 'int',
    'Integer' => 'int',
    'Object' => 'Boolean',
    'Time' => 'Date',
    'BigDecimal' => 'Number',
    'Float' => 'Number',
    'DateTime' => 'Date'
  }
  
  PARSE_FUNCTION = {
    'Time' => 'DateUtils.toASDateTime',
    'Date' => 'DateUtils.toASDate',
    'DateTime' => 'DateUtils.toASDateTime'
  }
  
  DEFAULTS = {
    'int' => 'UNSAVED_ID',
    'String' => '""',
    'Boolean' => 'false',
    'Number' => 0
  }
  
  def self.parse(class_name, s)
    unless PARSE_FUNCTION[class_name]
      return s
    else
      return "#{PARSE_FUNCTION[class_name]}(#{s})"
    end
  end
  
  def self.should_parse?(key)
    return true if PARSE_FUNCTION[key]
  end
  
  def self.mappings(key)
    MAPPINGS[key] ? MAPPINGS[key] : key
  end
  
  def self.defaults(key)
    DEFAULTS[mappings(key)] ? DEFAULTS[mappings(key)] : 'null'
  end
end