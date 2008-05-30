module Limber
  module Components
    class FormFor < FlexMxmlComponent
      
      
      def initialize(model_name, *args)
        @model_name = model_name
        @current_model = "current#{model_name.to_s.camelcase}"
        @attributes||={}
        @attributes.merge!(args[0]) if args[0].is_a?(Hash)
        @truth_values = @attributes.delete(:truth_values)
        @form_values = {}
        @do_not_clear = []
      end
      
      # TODO: FIX THIS APP_NAME CRAP!!!
      # THIS SHOULD NOT BE HARD CODED - DEBUGGING ELUSIVE
      def app_name
        'Vmi'
      end
      
      def to_mxml
        form_id = (@model_name.to_s.varify+"Form").to_sym
        form(form_id, {:style_name => form_id}.merge(@attributes)) do
  	  	  yield(self)
        end
      end
      
      def text(label, field, params={})
        id = params[:id] || (field.to_s.varify+"Text").to_sym
        @form_values[field] = "#{id.to_s}.text"
        @do_not_clear << field if params.delete(:do_not_clear)
        required = params.delete(:required)
        label_width = params.delete(:label_width)
        hide_zero_values = params.delete(:hide_zero_values)
        
        form_item(label, :required => required, :label_width => label_width) { 
          unless hide_zero_values
            text_input(id, {:text => bind_to(model_value(@model_name, field))}.merge!(params))
            yield if block_given? # in case you want to stick something after the text box
          else
            text_input(id, {:text => bind_to("#{model_value(@model_name, field)} == 0 ? '' : #{model_value(@model_name, field)}")}.merge!(params))
            yield if block_given? # in case you want to stick something after the text box
          end
        }
      end
      
      
      def text_area(label, field, params={})
        id = params[:id] || (field.to_s.varify+"Text").to_sym
        @form_values[field] = "#{id.to_s}.text"
        @do_not_clear << field if params.delete(:do_not_clear)
        
        form_item(label, :required => params.delete(:required), 
                         :label_width => params.delete(:label_width),
                         :direction => params.delete(:label_direction)) { 
            method_missing(:text_area, id, {:text => bind_to(model_value(@model_name, field))}.merge!(params))
        }
      end
      
      
      # TODO: this needs to be enhanced to splice in the editable text value
      # into the list somehow at the top or select it in the list if it is 
      # in the list.
      # Much code is shared with text method above. Could be combined.
      def editable_combo(label, field, params={})
        id = params[:id] || (field.to_s.varify+"Text").to_sym
        @form_values[field] = "#{id.to_s}.text"
        @do_not_clear << field if params.delete(:do_not_clear)
        required = params.delete(:required)
        label_width = params.delete(:label_width)
        hide_zero_values = params.delete(:hide_zero_values)
        
        form_item(label, :required => required, :label_width => label_width) { 
          unless hide_zero_values
            combo_box(id, {:editable => true, :text => bind_to(model_value(@model_name, field))}.merge!(params))
          else
            combo_box(id, {:editable => true,
                           :text => bind_to("#{model_value(@model_name, field)} == 0 ? '' : #{model_value(@model_name, field)}")}.merge!(params))
          end
        }
      end

      def combo(label, field, params={})
        id = params[:id] || (field.to_s.varify+"CBO").to_sym
        collection_name = params.delete(:collection)
        data_provider = params[:data_provider] || collection(collection_name)
        selected_index = params.delete(:selected_index) || index_of(model_value(@model_name, field), collection_name)
        # STDERR.puts "combo: #{label}, #{field}, #{params.inspect}"
        @form_values[field] = "#{id.to_s}.selectedIndex != -1 ? #{id}.selectedItem.id : 0"
        @do_not_clear << field if params.delete(:do_not_clear)
        required = params.delete(:required)
        label_width = params.delete(:label_width)
        
        form_item(label, :required => required, :label_width => label_width) { 
          combo_box(id, {:data_provider => (params.delete(:data_provider) || bind_to(data_provider)),
                         :selected_index => bind_to(selected_index)}.merge!(params))
        }
      end

      def check(label, field, params={})
        id = params[:id] || (field.to_s.varify+"Check").to_sym
        @form_values[field] = "#{id.to_s}.selected"
        @form_values[field] << " ? '#{@truth_values[0]}' : '#{@truth_values[1]}' " unless @truth_values.nil?
        @do_not_clear << field if params.delete(:do_not_clear)
        
        label_width = params.delete(:label_width)
        form_item(:label_width => label_width) { 
          check_box(id, label, {:selected => bind_to("#{model_value(@model_name, field)} == 'Y'")}.merge!(params))
        }
      end
      
      def date(label, field, params={})
        id = params[:id] || (field.to_s.varify+"Date").to_sym
        @form_values[field] = "#{id.to_s}.selectedDate"
        @do_not_clear << field if params.delete(:do_not_clear)
        label_width = params.delete(:label_width)
        required = params.delete(:required)
        
        form_item(label, :label_width => label_width, :required => required) {
          params[:selected_date] ||= bind_to(model_value(@model_name, field))
          date_field(id, params)
        }
      end
      
      def button(label, action, params={})
        id = params[:id] || (action.to_s.varify+"Button").to_sym
        label_width = params.delete(:label_width)
        
        form_item(:label => '', :label_width => label_width) {
          method_missing(:button, id, label, params)
        }
      end
      
      def button_bar(params={})
        form_item(:label => '', :label_width => params.delete(:label_width)) {
          control_bar({:padding_left => 0, :id => nil}.merge(params)) {
            yield
          }
        }
      end
      
      def form_values
        @form_values
      end
      
      def clear
        @form_values.collect do |k, v|
          unless @do_not_clear.include?(k)
            "#{v.split(/\s/).first} = "+ case
              when v.split(/\s/).first.match(/selectedIndex$/):
                "0"
              when v.split(/\s/).first.match(/selected$/): 
                'false'
              else
                'null'
              end
          end
        end.compact.join('; ')
      end
      
      
      def heading(*args)
        form_heading(*args)
      end
              
    end
  end
end
