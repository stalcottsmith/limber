module Limber
  module Components
    
    # Had to stick this in here to keep from conflicting with 
    # app/controllers/application.rb
    class Application < CustomComponent
  
      def flex_target_dir
        'app/flex'
      end
  
      def wrapper_tag
        :application
      end

      def self.manages_models(*args)
        define_method(:models_managed) do 
          return args
        end
      end

      def class_base_name
        'Application'
      end
  
    end
    
  end
end