module Limber
  module Components
      class CustomComponent < FlexMxmlComponent
    
        @@imports = []
        @@functions = []
        @@state_maps ||= {}
        @@listen_to_events = []
        @@creation_complete_tasks = []
    
        @@requires_model_locator = false
    
        def initialize
          @bindings = []
          @@imports += ["com.#{app_name.underscore}.util.DebugMessage",
                        "com.#{app_name.underscore}.command.*",
                        "mx.controls.Alert",
                        "mx.core.Application",
                        "com.#{app_name.underscore}.control.VmiController",
                        "com.#{app_name.underscore}.control.EventNames",
                        "com.#{app_name.underscore}.util.CairngormUtils"] unless @@imports.size > 0
        end

    
        def file_name
          unless self.is_a?(Limber::Components::Application)
            "#{flex_target_dir}/#{class_base_name}.mxml"
          else
            "app/flex/#{app_name}.mxml"
          end
        end
  
        def flex_target_dir
          "app/flex/com/#{app_name.underscore}/components"
        end
    
        def wrapper_tag
          self.class.ancestors[1].to_s.split("::").last.underscore.to_sym
        end
    
        def app_name
          self.class.to_s.split('::').first
        end
    
        def self.app_name
          self.to_s.split('::').first
        end
    
        def xml_namespaces
          ns = {'xmlns:component' => "com.#{app_name.underscore}.components.*",
                'xmlns:mx' => "http://www.adobe.com/2006/mxml"}
          ns.merge!('xmlns:control' => "com.#{app_name.underscore}.control.*") if wrapper_tag.eql?(:application)
          return ns
        end

        def generate_flex
          STDERR.puts "Building #{file_name}"
          File.open(file_name, "w+") do |f|
            f.write(%{<?xml version="1.0" encoding="utf-8"?>\n})
            xml = self.method_missing( wrapper_tag, attributes.merge!(xml_namespaces)) { script ; to_mxml }
            action_script_insert = cdata(build_action_script(wrapper_tag))
            xml.sub!(/(Script>)\s*(<\/mx)/, '\1'+action_script_insert+'\2') unless xml.nil?
            xml.sub!('<mx:Script/>', '<mx:Script>'+action_script_insert+'</mx:Script>') unless xml.nil?
            xml.sub!(/(<\/mx:Script>(.*)$)/, '\1'+"\n  <control:#{app_name}Controller id=\"controller\" />"+'\2') if wrapper_tag.eql?(:application)
            f.write( xml )
          end
          if respond_to?(:sub_components)
            sub_components.collect {|s| s.to_s}.each do |sub_component_name|
              reset_xml_builder
              require "app/flex/#{app_name.underscore}/#{sub_component_name}.rb"
              sub_component_class_name = [app_name, sub_component_name.camelcase].join("::")
              sub_component_class_name.constantize.new.generate_flex
            end
          end
        end


        def emit(s)
          return "    "+s.gsub(/\n/, "    \n")+"\n"
        end


        def self.as_import(package, as_class_name)
          as_class_name = eval(as_class_name) if as_class_name.match(/".*"/)
          import_to_add = ["com", app_name.underscore, package.to_s, as_class_name].join('.')
          @@imports << import_to_add unless @@imports.include?(import_to_add)
        end
    
        def self.add_model_locator
          @@requires_model_locator = true
          self.as_import(:model, '"#{app_name}ModelLocator"')
        end
    
    
        def self.has_components(*args)
          define_method(:sub_components) do 
            return args
          end
        end
    
        def self.has_attributes(hash)
          define_method(:attributes) do 
            return hash.merge!(:id => nil, :creation_complete => "handleCreationComplete()")
          end
        end
        
        def self.controls(what, with)
        end
    
        def self.action_script(function)
          @@functions << function
        end
    
        def build_action_script(symbol=:unknown)
          s = ''
          behaviors.collect(&:imports).flatten.compact.uniq.each {|i| s << emit("import #{i};") }
          s << handle_creation_complete
          @@functions.each { |function| s << function.gsub(/#\{(.*)\}/) {|m| puts m ; eval(m)} } unless @@functions.nil?
          behaviors.collect(&:action_script_definitions).flatten.compact.uniq.each {|as| s << as }
          s << self.custom_action_script if self.respond_to?(:custom_action_script) && self.custom_action_script
          s << self.component_action_script
          return s
        end
    
        def handle_creation_complete
          s = emit( "private function handleCreationComplete():void {")
          behaviors.collect(&:creation_complete_events).flatten.compact.each do |event|
            s << emit("    #{event.conditionally_dispatch};")
          end
          @@listen_to_events.each do |event_type, event, handler|
            s << emit("    addEventListener(#{event_type.to_s.camelcase}.#{event.to_s.underscore.upcase},#{handler});")
          end
          
          s << emit(creation_complete_tasks) if self.respond_to?(:creation_complete_tasks)
          s << emit("}")
          return s
        end
    
        def model_locator_accessor()
          # @@imports << "com.#{app_name.underscore}.model.#{app_name}ModelLocator"
          s = emit('')
          s << emit( "[Bindable]")
          s << emit( "private var _model:#{app_name}ModelLocator = #{app_name}ModelLocator.getInstance();")
          return s
        end
        
            
        def self.handles(event_type, event, handler)
          @@imports << "flash.events.#{event_type.to_s.camelcase}"
          @@listen_to_events << [event_type, event, handler]
        end
        
        def create_or_destroy(model_name, options)
          "
            if(#{options[:based_on]}) {
              #{options[:function_prefix]}#{destroy(model_name, options[:with][:id])};
            } else {
              #{options[:function_prefix]}#{create(model_name, options[:with])};
            }
          "
        end
        
        def array_collection(array)
          @@imports << 'mx.collections.ArrayCollection'
          "new ArrayCollection(#{array.inspect})"
        end

      end
    end
end