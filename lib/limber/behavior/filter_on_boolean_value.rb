module Limber
  module Behavior
    
    class FilterOnBooleanValue < Base
                  
                  
      def initialize(*args)
        super(*args)
        @collection_name = args[1]
        @filter_property = args[2]
        @filter_value_source = args[3]
        
        @filter_value = "#{@collection_name.to_s.varify}FilterValue"
        @update_filter_method = "#{@collection_name.to_s.varify}FilterSelectionChanged"
        
        imports << "com.#{app_name.underscore}.model.#{app_name}ModelLocator"
      end
      
      def action_script_definitions
        return <<-AS

          private var #{@filter_value}:int = 0;
        
          private function #{@collection_name.to_s.varify}Filter(item:Object):Boolean {
            if(#{@filter_value} == 0) {
              return true;
            } else {
              return item.#{@filter_property} == (#{@filter_value} - 1);
            }
          }
          
          private function #{@update_filter_method}():void {
            #{@filter_value} = #{@filter_value_source.to_s};
            _model.#{@collection_name.to_s.varify}.filterFunction = #{@collection_name.to_s.varify}Filter;
            _model.#{@collection_name.to_s.varify}.refresh();
          }
          
        AS
      end
      
      def hook
        @update_filter_method+"()"
      end
      
    end
  end
end
