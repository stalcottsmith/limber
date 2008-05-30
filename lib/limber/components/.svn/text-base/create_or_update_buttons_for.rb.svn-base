module Limber
  module Components
    class CreateOrUpdateButtonsFor < FlexMxmlComponent
      
      
      def initialize(model_name, *args)
        @model_name = model_name
        @attributes||={:create_or_update => "_model.current#{@model_name.to_s.classify}.id"} #default
        @attributes.merge!(args[0]) if args[0].is_a?(Hash)
        @after_create = @attributes.delete(:after_create)
        @after_update = @attributes.delete(:after_update)
      end
      
      def app_name
        'Vmi'
      end
            
      def to_mxml
        view_stack("#{@model_name.to_s.varify}VSK".to_sym, :selected_index => bind_to("#{@attributes[:create_or_update]} == 0 ? 0 : 1")) do
          h_box {
            spacer :width => "10"
            button :label => "Create", #:visible => bind_to("#{@attributes[:create_or_update]} == 0"),
                   :click => "#{create(@model_name, @attributes[:create])}#{@after_create ? ('; '+ @after_create) : @after_create}", 
                   :enabled => @attributes[:create_enabled] || @attributes[:enabled]
          }
          h_box {
            spacer :width => "100%"
            button :label => "Update", #:visible => bind_to("#{@attributes[:create_or_update]} != 0"),
                   :click => "#{update(@model_name, @attributes[:update])}#{@after_update ? ('; '+ @after_update) : @after_update}", 
                    :enabled => @attributes[:update_enabled] || @attributes[:enabled]
          }
        end
        button( :label => "Cancel", :click => @attributes[:cancel]) unless (@attributes[:include_cancel] == false)
      end
                    
    end
  end
end
