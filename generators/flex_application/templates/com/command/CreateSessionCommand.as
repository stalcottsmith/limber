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
    
    public class CreateSessionCommand implements ICommand, IResponder {
        public function CreateSessionCommand() {     
        }

        public function execute(event:CairngormEvent):void {
            var delegate:SessionDelegate = new SessionDelegate(this);
            delegate.createSession(event.data.login, event.data.password);
        }

        public function result(event:Object):void {
            var result:Object = event.result;
            if (event.result == "badlogin") {
                Alert.show("Login failed.");
            } else {
                var model:<%= file_name.camelcase %>ModelLocator = <%= file_name.camelcase %>ModelLocator.getInstance();
                model.user = User.fromXML(XML(event.result));
/*                model.workflowState = <%= file_name.camelcase %>ModelLocator.VIEWING_MAIN_APP;*/
            }
        }
    
        public function fault(event:Object):void {
            <%= file_name.camelcase %>.debug("CreateSessionCommand#fault: " + event);
            Alert.show("Login Failed", "Error");
        }
    }
}