module Limber
  module Behavior
    
    # Create a new model record on the server.
    #
    # Usage:
    #
    #     button :click => create(:model_name, :key => 'formElement.text')
    #
    class Create < Base
                  
      def initialize(*args)
        super(*args)
        @model_name = args[1]
        @model_class_name = @model_name.to_s.camelcase
        @event_name = 'CREATE_' + @model_class_name.underscore.upcase
        @values = args[2]
        @instance_number = args[3] || instance_number
        
        # STDERR.puts "USING INSTANCE_NUMBER = #{@instance_number}"
        
        imports << "com.#{app_name.underscore}.control.EventNames"
        imports << "com.#{app_name.underscore}.util.CairngormUtils"
        imports << "com.#{app_name.underscore}.model.#{@model_class_name}"
      end
        
      def action_script_definitions
        s = %[
        public function create#{@model_class_name}#{@instance_number}(values:Object):void {
          var model:Object = new #{@model_class_name}();]
        s << "\n"
        @values.each_pair {|key, value| s<<"          model.#{key.to_s.varify} = values.#{key.to_s.varify};\n" }
        s << "          CairngormUtils.dispatchEvent(EventNames.#{@event_name}, model);\n"
        s << "        }\n"
        return s
      end
      
      def hook
        function_name = "create#{@model_class_name}#{@instance_number}"
        "#{function_name}(#{@values.to_action_script(' '*(function_name.size+12))})"
      end
      
    end
  end
end
