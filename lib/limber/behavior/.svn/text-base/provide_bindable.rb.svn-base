module Limber
  module Behavior


    class ProvideBindable < Base
                  
      def initialize(*args)
        super(*args)
        @bindable = args[1]
      end
      
      def action_script_definitions
        "[Bindable]\n#{@bindable};\n"
      end

      def hook
        ""
      end
      
    end
  end
end
