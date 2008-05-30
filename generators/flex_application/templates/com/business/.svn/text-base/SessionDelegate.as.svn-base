// This file generated on <%= Date.today %>, by <%= ENV['USER'] %>
// using the Limber plugin via: script/generate flex_application 
package com.<%= file_name %>.business {
    import mx.rpc.IResponder;
    import com.<%= file_name %>.util.ServiceUtils;

    public class SessionDelegate {
        private var _responder:IResponder;
        
        public function SessionDelegate(responder:IResponder) {
            _responder = responder;
        }
        
        public function createSession(login:String, password:String):void {
            ServiceUtils.send(
                "/session.xml",
                _responder,
                "POST",
                {login: login, password: password});
        }

        public function destroySession():void {
            ServiceUtils.send(
                "/session.xml",
                _responder,
                "DELETE");
        }

    }
}