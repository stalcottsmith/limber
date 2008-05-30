module Limber
  module Behavior
    
    # Iterate over a collection, invoking a behavior.
    # If given a condition and the condition evaluates false,
    # just invoke the behavior once.
    #
    #
    class ForEach < Base
                  
      def initialize(*args)
        super(*args)
        @collection_name = args[1].to_s
        @class_name = @collection_name.singularize
        @behavior = args[2]
        @options = args[3] || {}
        @if_conditional = @options[:if]
        @form_fields_to_hold_constant = @options[:holding_constant]
        
        # imports << "com.#{app_name.underscore}.model.#{@app_name}ModelLocator"
        
        @instance_number = instance_number
        
        if @behavior.match(/^([[:alpha:]]+)(\d|\()/)
          @behavior_function_name = $1
          @function_name = "forEach#{@collection_name.classify}#{@behavior_function_name.camelcase}"
        else 
          @function_name = "forEach#{@collection_name.classify}#{@instance_number}"
        end

      end
      
      def requires_model_locator?
        true
      end
      
      
      def save_form_values
        s = "\n\n"
        @form_fields_to_hold_constant.each_pair do |key, type_and_form_field|
          value_class, form_field = type_and_form_field
          s << "            var saved#{key.to_s.classify}:#{value_class} = #{form_field};\n"
        end
        s << "\n"
      end
      
      def restore_form_values
        s = "\n\n"
        @form_fields_to_hold_constant.each_pair do |key, type_and_form_field|
          value_class, form_field = type_and_form_field
          s << "              #{form_field} = saved#{key.to_s.classify};\n"
        end
        s << "\n"
      end

      def iterate
        s = ""
        s << "            #{@options[:before_iteration]}" unless @options[:before_iteration].nil?
        s << save_form_values unless @form_fields_to_hold_constant.nil?
        s << "            for each (var #{@class_name.varify}:#{@class_name.classify} in _model.#{@collection_name.varify}) {\n"
        s << "              _model.current#{@class_name.classify} = #{@class_name.varify};\n"
        s << restore_form_values unless @form_fields_to_hold_constant.nil?
        s << "              do#{@behavior_function_name.camelcase}();\n"
        s << "            }\n"
        s << "            #{@options[:after_iteration]}\n" unless @options[:after_iteration].nil?
        return s
      end
      
      def action_script_definitions
        s = %[
        public function do#{@behavior_function_name.camelcase}():void {
          #{@behavior}
        }
          
        public function #{@function_name}():void {\n]
        if @if_conditional
          s << "\n"
          s << "          if(#{@if_conditional}) {\n"
          s << iterate
          s << "          } else {\n"
          s << "            do#{@behavior_function_name.camelcase}();\n"
          s << "          }\n"
        else
          s << iterate
        end
        s << "        }\n"
        return s
      end
      
      def hook
        "#{@function_name}()"
      end
      
    end
  end
end
