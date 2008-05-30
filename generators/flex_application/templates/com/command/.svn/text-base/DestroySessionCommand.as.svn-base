package com.<%= file_name %>.command {
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.<%= file_name %>.business.SessionDelegate;
    import com.<%= file_name %>.model.<%= file_name.camelcase %>ModelLocator;
    import com.<%= file_name %>.model.User;
    
    import mx.controls.Alert;
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    public class DestroySessionCommand implements ICommand, IResponder {
        public function DestroySessionCommand() {     
        }

        public function execute(event:CairngormEvent):void {
            var delegate:SessionDelegate = new SessionDelegate(this);
            delegate.destroySession();
        }

        public function result(event:Object):void {
            var result:Object = event.result;
            if (event.result == "ok") {
                var model:<%= file_name.camelcase %>ModelLocator = <%= file_name.camelcase %>ModelLocator.getInstance();
				model.user = null;
            } else {
                Alert.show("Logout failed.");
            }
        }
    
        public function fault(event:Object):void {
            <%= file_name.camelcase %>.debug("DestroySessionCommand#fault: " + event);
            Alert.show("Logout Failed", "Error");
        }
    }
}