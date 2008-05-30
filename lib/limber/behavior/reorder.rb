module Limber
  module Behavior
    
    class Reorder < Base
                  
      def initialize(*args)
        super(*args)
        @collection_name = args[1]
        @ordering_attribute = args[2]
        @model_class_name = @collection_name.to_s.singularize.camelcase
        
        imports << "com.#{app_name.underscore}.control.EventNames"
        imports << "com.#{app_name.underscore}.util.CairngormUtils"
        imports << "com.#{app_name.underscore}.model.#{@model_class_name}"
        imports << "mx.events.DragEvent"
        
      end
      
      def action_script_definitions
        return <<-END_AS
          private function reorder#{@collection_name.to_s.camelcase}(event:DragEvent):void {
            var i:int = 0;
            for each( var #{@model_class_name.varify}:#{@model_class_name} in _model.#{@collection_name.to_s.varify}) {
              i++;
              if(#{@model_class_name.varify}.#{@ordering_attribute.to_s.varify} != i) {
                #{@model_class_name.varify}.#{@ordering_attribute.to_s.varify} = i;
                CairngormUtils.dispatchEvent(EventNames.UPDATE_#{@model_class_name.underscore.upcase}, #{@model_class_name.varify});
              }
            }
            CairngormUtils.dispatchEvent(EventNames.LIST_#{@model_class_name.underscore.pluralize.upcase});
          }
        END_AS
      end
      
      def hook
        "reorder#{@collection_name.to_s.camelcase}(event)"
      end
      
    end
  end
end
