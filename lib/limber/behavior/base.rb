module Limber
  module Behavior
    
    # This is necessary to prevent const_missing propagating up
    # to the Limber module where it will create things on the fly.
    def self.const_missing(name)
      raise "NameError: uninitialized constant: "+name.to_s
    end

    # STDERR.puts "loading Limber::Behavior"
      
    def self.find(name, component, *args)
      unless [:application, :script].include?(name)
        behavior_class_name = "Limber::Behavior::"+name.to_s.camelcase
        behavior_klass = behavior_class_name.constantize
        # STDERR.puts "#{behavior_klass}.new(#{component.inspect}, #{args.inspect})"
        behavior = behavior_klass.new(component, *args)
        component.behaviors << behavior
        # STDERR.puts "behavior: #{behavior_class_name}"
        return behavior.hook
      end
    rescue RuntimeError => e
      # STDERR.puts "missing behavior: #{behavior_class_name}: #{e.to_s}"
      return false
    end

    
    class Base
      # include ActionScriptHelper
      
      def initialize(*args)
        @component = args[0]
        unless @component
          # STDERR.puts args.inspect
          throw "component not set" 
        end
      end
      
      def component
        @component
      end
      
      def component=(c)
        @component = c
      end
            
      # Return a string of action script including variable
      # declarations and function definitions to be placed in the
      # <mx:Script></mx:Script> area at the top of an MXML file.
      def action_script_definitions
        "\n/* action_script_definitions for #{self.class.to_s} */\n"
      end
      
      # Return a small hook appropriate for a click attribute
      # ie. dispatchSomeEvent(payload) or whatever
      def hook 
        " no hook for #{self.class.to_s}"
      end
      
      def imports
        @imports ||= ["com.#{app_name.underscore}.components.*"]
      end
      
      def requires_model_locator?
        false
      end

      
      protected
        def indent(s)
          return s.gsub(/^/, '    ')
        end
        
        def instance_number
          component.behaviors.select {|b| b.class.eql?(self.class) }.size
        end
      
        def on_creation_complete(event) 
          creation_complete_events << event
        end
        
        def creation_complete_events
          @creation_complete_events ||= []
        end
    
        def list_event(collection_id, data=nil, condition=nil)
          Event.new(('list_'+collection_id.to_s).to_sym, data, condition)
        end

        # This is a tricky little bastard
        def app_name
          @component.app_name
        end
                
        def quote_immediate(s)
          s.match(/^true$|^false$|^\d+$/) ? s : "\"#{s}\""
        end

        def reference_form_fields(key, s)
          return s unless s.is_a?(Symbol)  # do nothing for strings
          symbol_dictionary = { :text => 'text', 
                                :check => 'selected',
                                :date => 'selectedDate',
                                :editable_combo => 'text'}
          if symbol_dictionary.keys.include?(s)
            return "#{key.to_s.varify}#{s.to_s.classify}.#{symbol_dictionary[s]}"
          else
            raise "#{self}: #{s} is not in #{symbol_dictionary.keys}"
          end
        end
        
      
    end
    
      
  end
end