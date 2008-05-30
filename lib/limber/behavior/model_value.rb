module Limber
  module Behavior
    
    # Load a specific price change.
    #
    # Usage:
    #
    #     button :click => alert("'got: '+event.type")
    #
    class ModelValue < Base
                  
      def initialize(*args)
        super(*args)
        throw "must supply symbols" unless args && args[1].is_a?(Symbol) && args[2].is_a?(Symbol)
        @model_class_name = args[1].to_s.camelcase
        @field = args[2].to_s.varify
        
        imports << "com.#{app_name.underscore.downcase}.model.#{app_name}ModelLocator"
        
      end
      
      def action_script_definitions
        "[Bindable]\n"+
        "private var _model:#{app_name}ModelLocator = #{app_name}ModelLocator.getInstance();\n"
      end
      
      def requires_model_locator?
        true
      end
                
      def hook
        "_model.current#{@model_class_name}.#{@field}"
      end
      
    end
  end
end
