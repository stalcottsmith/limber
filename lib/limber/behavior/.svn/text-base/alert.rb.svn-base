module Limber
  module Behavior
    
    # Show a dialog to the User.
    #
    # Usage:
    #
    #     button :click => alert("'got: '+event.type")
    #
    class Alert < Base
                  
      def initialize(*args)
        super(*args)
        throw "must supply string (may contain actionscript)" unless args && args[1].is_a?(String)
        @alert_string = args[1]
        
        imports << "mx.controls.Alert"
      end
      
      def action_script_definitions
        <<-END
        public function showAlert(str:String):void {
          Alert.show(str);
        }
        END
      end
      
      def hook
        "showAlert('#{@alert_string}')"
      end
      
    end
  end
end
