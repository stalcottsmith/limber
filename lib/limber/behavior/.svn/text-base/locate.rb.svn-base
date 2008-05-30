module Limber
  module Behavior

    #
    # Provide a collection of data to the component.
    #
    #  Usage:
    #
    #      locate :data_provider => provide(:an_active_record_model)
    #

    class Locate < Base
                  
      def initialize(*args)
        super(*args)
        throw "must supply symbol" unless args && args[1].is_a?(Symbol)
        @collection_name = args[1]
        
        imports << "com.#{app_name.underscore.downcase}.model.#{app_name}ModelLocator"
        imports << "com.#{app_name.underscore.downcase}.util.CairngormUtils"
        imports << "com.#{app_name.underscore.downcase}.control.EventNames"
      end
      
      def requires_model_locator?
        true
      end

      def hook
        "_model.#{@collection_name.to_s.varify}"
      end
      
    end
  end
end
