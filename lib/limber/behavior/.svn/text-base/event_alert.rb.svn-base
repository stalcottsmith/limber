module Limber
  module Behavior
    
    # Show a dialog to the User.
    #
    # Usage:
    #
    #     button :click => alert("'got: '+event.type")
    #
    class EventAlert < Base
                  
      def initialize(*args)
        super(*args)
        throw "must supply string (may contain actionscript)" unless args && args[1].is_a?(String)
        @alert_string = args[1]
        @alert_type = args[2] || 'ListEvent'
        
        imports << "mx.controls.Alert"
        imports << "mx.events.#{@alert_type}"
      end
      
      def action_script_definitions
        <<-END
        public function showEventAlert(event:#{@alert_type}):void {
          Alert.show(#{@alert_string})
        }
        END
      end
      
      def hook
        "showEventAlert(event)"
      end
      
    end
  end
end
