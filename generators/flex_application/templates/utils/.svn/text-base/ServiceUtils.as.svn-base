// This file generated on <%= Date.today %>, by <%= ENV['USER'] %>
// using the Limber plugin via: script/generate flex_application 
package com.<%= file_name %>.util {
    import mx.rpc.IResponder;
    import mx.rpc.AsyncToken;
    import mx.rpc.http.HTTPService;

	import com.<%= file_name %>.util.PopupApplicationProgressBar;

    public class ServiceUtils {
        /**
         * Note: PUT and DELETE don't work with XML since the
         * _method hack workaround doesn't work.
         */
        public static function send(
            url:String,
            responder:IResponder = null,
            method:String = null,
            request:Object = null,
            sendXML:Boolean = false,
            resultFormat:String = "e4x",
            useProxy:Boolean = false):void
        {
			PopupApplicationProgressBar.getInstance().incrementTotalProgressSteps();
            var service:HTTPService = new HTTPService();
            service.url = url;
            service.contentType = sendXML ? "application/xml" :
                "application/x-www-form-urlencoded";
            service.resultFormat = resultFormat;
            if (method == null) {//default sensibly
                service.method = (request == null) ?
                    "GET" : "POST";
            } else if ((method == "PUT") ||
                       (method == "DELETE")) {
                service.method = "POST";
                //PUT and DELETE don't work in Flash yet
                if (request == null) {
                    request = new Object();
                }
                request["_method"] = method;
            } else {
                service.method = method;
            }
            service.request = request;
            service.useProxy = useProxy;
            var call:AsyncToken = service.send();
            if (responder != null) {
                call.addResponder(responder);
				call.addResponder(PopupApplicationProgressBar.getInstance());
            }
        }
    }
}
