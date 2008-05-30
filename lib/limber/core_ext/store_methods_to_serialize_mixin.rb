module Limber::CoreExt::StoreMethodsToSerializeMixin
      
  
  def self.included(base)
    # STDERR.puts "Limber::CoreExt::StoreMethodsToSerializeMixin included into #{base.to_s}"
    base.module_eval do 
      def self.serialize_to_xml(*methods)
        module_eval do
          @@methods_to_serialize = []

          def self.methods_to_serialize
            return @@methods_to_serialize
          end

          def self.methods_to_serialize=(array)
            @@methods_to_serialize = array
          end
        end
        self.methods_to_serialize += methods.collect {|m| Limber::CoreExt::StoreMethodsToSerializeMixin::MethodAttribute.new(m)}
      end
      
      # Hide from XML
      def self.hide_from_xml(*methods)
        
        module_eval do
          @@methods_to_hide = []

          def self.methods_to_hide
            return @@methods_to_hide
          end

          def self.methods_to_hide=(array)
            @@methods_to_hide = array
          end
        end
        self.methods_to_hide += methods.collect {|m| Limber::CoreExt::StoreMethodsToSerializeMixin::MethodAttribute.new(m)}
      end
      
      # Hide from CSV
      def self.hide_from_csv(*methods)
        
        module_eval do
          @@methods_to_hide_from_csv = []

          def self.methods_to_hide_from_csv
            return @@methods_to_hide_from_csv
          end

          def self.methods_to_hide_from_csv=(array)
            @@methods_to_hide_from_csv = array
          end
        end
        self.methods_to_hide_from_csv += methods.collect {|m| Limber::CoreExt::StoreMethodsToSerializeMixin::MethodAttribute.new(m)}
      end
      
      
    end
  end
  
  class MethodAttribute
    attr :name
    attr :klass
    def initialize(name)
      @name = name.to_s
      @klass = String
    end
  end
end
