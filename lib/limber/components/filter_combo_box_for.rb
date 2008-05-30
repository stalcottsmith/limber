module Limber
  module Components
    class FilterComboBoxFor < FlexMxmlComponent
      
      
      def initialize(collection_name, *args)
        @collection_name = collection_name
        @attributes||={:id => "#{@collection_name.to_s.varify}FilterCBO".to_sym} #defaults
        @attributes.merge!(args[0]) if args[0].is_a?(Hash)
        @filter_type = @attributes.keys.detect {|k| k.to_s.match(/_filter/)}
        filter_hash = @attributes.delete(@filter_type)
        @filter_property = filter_hash.keys.first
        @filter_options = filter_hash.values.first
      end
      
      def app_name
        'Vmi'
      end
      
      def create_array_collection_if_necessary
        if(@filter_options.is_a?(Array))
          options_collection_name = "#{@collection_name.to_s.varify}FilterOptions"
          provide_bindable("private var #{options_collection_name}:ArrayCollection = #{collect(@filter_options)}")
          @filter_options = options_collection_name
        end
        return @filter_options
      end
            
      def to_mxml
        h_box {
          label :text => @attributes.delete(:label), :padding_left => (@attributes.delete(:padding_left) || 10)
          combo_box(@attributes[:id], :width => "180",
                     :data_provider => bind_to(create_array_collection_if_necessary()),
                     :change => filter_on_boolean_value(@collection_name, @filter_property, "#{@attributes[:id]}.selectedIndex"))
        }
      end
                    
    end
  end
end