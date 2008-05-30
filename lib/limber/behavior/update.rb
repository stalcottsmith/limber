module Limber
  module Behavior
    
    # Create a new model record on the server.
    #
    # Usage:
    #
    #     button :click => create(:model_name, :key => 'formElement.text')
    #
    class Update < Base
                  
      def initialize(*args)
        super(*args)
        # STDERR.puts "Got HERE: "+args.inspect
        @model_name = args[1]
        @model_class_name = @model_name.to_s.camelcase
        @event_name = 'UPDATE_' + @model_class_name.underscore.upcase
        @values = args[2]
        @instance_number = args[3] || instance_number
        
        imports << "com.#{app_name.underscore}.control.EventNames"
        imports << "com.#{app_name.underscore}.util.CairngormUtils"
        imports << "com.#{app_name.underscore}.model.#{@model_class_name}"
        # imports << "mx.controls.Alert"
        
      end
      
      
      # handy for debugging:
      # Alert.show("Updating: {#{@values.to_a.collect{|k,v| k.to_s.varify+': "+values.'+k.to_s.varify+'+"'}.join(', ')}")
      
      def action_script_definitions
        s = %[
        public function update#{@model_class_name}#{@instance_number}(values:Object):void {
          var model:Object = new #{@model_class_name}(#{@values[:id]});]
        s << "\n"
        @values.each_pair { |key, value| s << "          model.#{key.to_s.varify} = values.#{key.to_s.varify};\n" }
        s << "          CairngormUtils.dispatchEvent(EventNames.#{@event_name}, model);\n"
        s << "        }\n"
        return s
      end
      
      def hook
        function_name = "update#{@model_class_name}#{@instance_number}"
        "#{function_name}(#{@values.to_action_script(' '*(function_name.size+12))})"
      end
      
    end
  end
end
