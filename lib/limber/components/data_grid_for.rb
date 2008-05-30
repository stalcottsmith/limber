module Limber
  module Components
    class DataGridFor < FlexMxmlComponent
      
      
      def initialize(collection, *args)
        @collection = collection
        @attributes||={}
        @list_event_data = args[0].delete(:list_event_data)
        @load_on_creation_complete = args[0].delete(:load_on_creation_complete)
        @drag_and_drop_reorder_by = args[0].delete(:drag_and_drop_reorder_by)
        @attributes.merge!(args[0])
      end
      
      def app_name
        'Vmi'
      end
            
      def to_mxml
        unless @drag_and_drop_reorder_by.nil?
          @attributes.merge!(:drag_move_enabled => true, :drag_enabled => true, :drop_enabled => true, 
                             :sortable_columns => false, :drag_complete => reorder(@collection, @drag_and_drop_reorder_by))
        end
        data_grid(@attributes.merge( 
          :data_provider => bind_to(collection(@collection, 
                              :load_on_creation_complete => @load_on_creation_complete,
                              :list_event_data => @list_event_data)))) do
          columns({}) do
    	  	  yield(self)
  	  	  end
        end
      end
      
      def column(header_text, data_field, params={})
        params.merge!(:header_text => header_text,
                      :data_field => data_field.to_s.varify)
        unless block_given?
          data_grid_column(params) 
        else
          data_grid_column(params) { yield } 
        end
      end
              
    end
  end
end