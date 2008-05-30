require 'limber/behavior/base'

module Limber
  module Components
    
    def self.find(symbol, *args)
      component_class_name = 'Limber::Components::'+symbol.to_s.camelcase
      # STDERR.puts "looking for #{component_class_name}"
      if klass = component_class_name.constantize
        # STDERR.puts "found #{klass.to_s}"
        return klass.new(*args)
      end
    rescue Exception => e
      # STDERR.puts e.to_s
      return nil
    end
    
    class FlexMxmlComponent 
  
      @@xml_builder = Builder::XmlMarkup.new(:indent => 2)
  
  
      TAGS_WITH_NO_DEFAULT_ID_ATTRIBUTE = [:application, :data_grid_column, :label, 
                                           :grid, :grid_row, :grid_item, :form_item,
                                           :h_box, :v_box, :style, :button, :spacer,
                                           :item_renderer, :component, :number_validator,
                                           :date_validator, :email_validator, :currency_validator,
                                           :string_validator, :phone_number_validator,
                                           :currency_validator]
      
      TAGS_WITH_NO_ATTRIBUTES = [:metadata, :script, :columns]                                     
                                       
      def behaviors
        @behaviors ||= []
      end
      
      # TODO: This is hoakey.  Behaviors invoked by Limber::Components helpers
      # need to be assigned to the component that invoked the helper so that
      # app_name works properly.  Needs refactoring.
      def behaviors=(ary)
        @behaviors = ary
        @behaviors.each {|b| b.component=self }
      end
      
      def component_action_script
        @component_action_script ||= ''
      end
      
  
      def method_missing(symbol, *args)
        unless s = Limber::Behavior.find(symbol, self, *args)
          component = Limber::Components.find(symbol, *args)
          # STDERR.puts "method_missing(:#{symbol}) got component: #{component.inspect}" 
          unless component.nil? || !component.respond_to?(:to_mxml) #|| !block_given?
            xml = component.to_mxml unless block_given?
            xml = component.to_mxml { |*args| yield(*args) } if block_given?
            self.behaviors += component.behaviors
            self.component_action_script << component.custom_action_script if component.respond_to?(:custom_action_script)
            return xml
          end
          
          action_script_class_name = symbol.to_s.camelcase
          attribs = varify_keys(build_attribs(action_script_class_name, symbol, *args)) unless TAGS_WITH_NO_ATTRIBUTES.include?(symbol)
          attribs ||= {}
          body = (args.first.is_a?(String) && 
                  args.size.eql?(1) && 
                  TAGS_WITH_NO_ATTRIBUTES.include?(symbol)) ? args.first : nil
                  
          wrap_in_cdata = symbol.eql?(:script) && body && !body.match(/CDATA/)

          tag_case = attribs.delete(:tagCase)  # allow us to call :varify method for 
                                                # special cases like setting properties in nested tags
          unless tag_case
            tag = symbol.eql?(:columns) ? symbol.to_sym : symbol.to_s.camelcase.to_sym
          else
            tag = symbol.to_s.send(tag_case).to_sym
          end
    
          unless self.respond_to?(:sub_components) && sub_components.include?(symbol)
            if block_given?
              @@xml_builder.mx(tag, attribs) { yield } 
            else
              @@xml_builder.mx(tag, attribs) { wrap_in_cdata ? @@xml_builder.cdata!(body) : body }
            end
          else
            if block_given?
              @@xml_builder.component(tag, attribs) { yield }
            else
              @@xml_builder.component(tag, attribs, body)
            end
          end
        else
          return s
        end
      end
  
      def reset_xml_builder
        @@xml_builder =  Builder::XmlMarkup.new(:indent => 2)
      end
  
      def build_attribs(class_name, method_name, *args)
        args_hash = args.detect {|a| a.is_a?(Hash)}
        all_around_padding = args_hash.delete(:padding) unless args_hash.nil?
        args_hash = { :padding_left => all_around_padding,
                      :padding_right => all_around_padding,
                      :padding_top => all_around_padding,
                      :padding_bottom => all_around_padding}.merge!(args_hash) unless all_around_padding.nil?
                      
        id_symbol = args.detect {|a| a.is_a?(Symbol)} # Saves typing :id => 
        id_symbol = id_symbol.to_s.varify.to_sym if id_symbol
        label_string = args.detect {|a| a.is_a?(String)} # Save typing :label => 
        attribs_hash = {}
        attribs_hash.merge!(xml_namespaces) if method_name.eql?(:application) || class_base_name.eql?(class_name)
        attribs_hash.merge!(:id => (id_symbol || class_name.varify)) unless TAGS_WITH_NO_DEFAULT_ID_ATTRIBUTE.include?(method_name)
        attribs_hash.merge!(:label => label_string) unless label_string.nil?
        attribs_hash.merge!( args_hash ) unless args_hash.nil?
        attribs_hash.clear if [:script, :columns].include?( method_name)
        attribs_hash.reject {|k,v| v.nil? or v.eql?('') }
      end
      
      def class_base_name
        self.class.to_s.split('::').last
      end
      
  
      def varify_keys(attribs_hash)
        new_hash = {}
        attribs_hash.each_pair {|k,v| new_hash[k.to_s.varify.to_sym] = v }
        return new_hash
      end
  
      def cdata(s) 
        "\n<![CDATA[\n#{s}\n]]>\n"
      end
      
      def build_action_script(symbol=:unknown)
      end

      def quote_immediate(s)
        s.match(/^true$|^false$|^\d+$/) ? s : "\"#{s}\""
      end
      
      def bind_to(s)
        "{#{s}}"
      end
      
      def id_map(collection_name)
        "_model.#{collection_name.to_s.singularize.varify}IDMap"
      end
      
      def property(symbol, *args)
        args.detect {|a| a.is_a?(Hash)}.merge!(:id => nil)
        self.method_missing(symbol.to_s.varify.to_sym, *args) { yield }
      end
      
      def clear_list(list_name)
        "clear#{list_name.to_s.camelcase}()"
      end
      
      def list_event(collection_id, data=nil, condition=nil)
        Event.new(('list_'+collection_id.to_s).to_sym, data, condition)
      end
      
      def create_event(model_name, data)
        Event.new(('create_'+model_name.to_s).to_sym, data)
      end

      def update_event(model_name, data)
        Event.new(('update_'+model_name.to_s).to_sym, data)
      end
      
      def destroy_event(model_name, data=nil)
        Event.new(('destroy_'+model_name.to_s).to_sym, data)
      end
      

      def checkbox_item_renderer(params)
        property( :item_renderer, :tag_case => :varify ) do
          component() do 
      	    box(:id => nil, :width => "100%", :horizontal_align => "center") do
      	      check_box({:width => 20}.merge(params)) do

                # This is nasty because I ran into difficulties attaching an <mx:Script></mx:Script> tag
        	      # to the component.  We borrow the great grandparent's imports and methods.
                script <<-end_as
                
                import com.vmi.model.VmiModelLocator;
                import mx.collections.ListCollectionView;

                [Bindable]
                private var _model:VmiModelLocator = VmiModelLocator.getInstance();

                end_as
              end
            end
          end
      	end
      end
      
  
    end
  end
end