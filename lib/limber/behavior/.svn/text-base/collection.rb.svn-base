module Limber
  module Behavior

    #
    # Provide a collection of data to the component.
    #
    #  Usage:
    #
    #      data_grid :data_provider => provide(:an_active_record_model)
    #

    class Collection < Base
                  
      def initialize(*args)
        super(*args)
        throw "must supply symbol" unless args && args[1].is_a?(Symbol)
        args.shift # super consumes this
        @collection_name = args.shift
        named_params = args.shift || {}
        @list_event_data = named_params[:list_event_data]
        
        @actual_collection_name = named_params[:with_none_entry] ? (@collection_name.to_s+'_and_none').to_sym : @collection_name
        
        imports << "com.#{app_name.underscore.downcase}.model.#{app_name}ModelLocator"
        imports << "com.#{app_name.underscore.downcase}.util.CairngormUtils"
        imports << "com.#{app_name.underscore.downcase}.control.EventNames"
        unless named_params[:load_on_creation_complete].eql?(false)
          on_creation_complete(list_event(@collection_name, 
                                          @list_event_data,
                                          named_params[:load_on_creation_complete]))
        end
      end
      
      def action_script_definitions
        "[Bindable]\n"+
        "private var _model:#{app_name}ModelLocator = #{app_name}ModelLocator.getInstance();\n"
      end
      
      def requires_model_locator?
        true
      end

      def hook
        "_model.#{@actual_collection_name.to_s.varify}"
      end
      
    end
  end
end
