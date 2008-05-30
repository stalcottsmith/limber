module Limber
  module Behavior
    
    # Destroy a model record on the server.
    #
    # Usage:
    #
    #      destroy(:current_vendor)
    # or   destroy(:vendor, 1)
    # or   destroy(:vendor, "_model.currentVendor.id")
    #
    class Destroy < Limber::Behavior::Base
                  
      def initialize(*args)
        super(*args)
        case args.size
        when 2
          # expects :current_[model_name]
          @model_name = args[1].to_s.gsub("current_", '')
          @model_instance = args[1].to_s.varify
          @model_instance_id = "_model.#{@model_instance}.id"
        when 3
          # expects :model_name and an id or ActionScript
          # expression that evaluates to an id
          @model_name = args[1].to_s
          @model_instance_id = args[2]
        else 
          raise "Behavior: destroy() expected 1 or 2 arguments"
        end
        @model_var_name = @model_name.to_s.varify
        @model_class_name = @model_name.to_s.camelcase
        @event_name = 'DESTROY_' + @model_class_name.underscore.upcase
        
        imports << "com.#{app_name.underscore}.control.EventNames"
        imports << "com.#{app_name.underscore}.util.CairngormUtils"
        imports << "com.#{app_name.underscore}.model.#{@model_class_name}"
      end
      
      def action_script_definitions
        s = %[
        public function destroy#{@model_class_name}(id:int):void {
          var model:Object = new #{@model_class_name}();
          model.id = id;]
        s << "\n"
        s << "          CairngormUtils.dispatchEvent(EventNames.#{@event_name}, model);\n"
        s << "        }\n"
        return s
      end
      
      def hook
        "destroy#{@model_class_name}(#{@model_instance_id})"
      end
      
    end
  end
end
