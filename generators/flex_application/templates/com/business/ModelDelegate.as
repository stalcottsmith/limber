// This file generated on <%= Date.today %>, by <%= ENV['USER'] %>
// using the Limber plugin via: script/generate flex_application 
package com.<%= file_name %>.business {
    import mx.rpc.IResponder;
	import mx.controls.Alert;
    import com.<%= file_name %>.model.<%= model_name %>;
    import com.<%= file_name %>.util.ServiceUtils;

    public class <%= model_name %>Delegate {
        private var _responder:IResponder;
        
        public function <%= model_name %>Delegate(responder:IResponder) {
            _responder = responder;
        }
        
        public function list<%= model_name.pluralize %>(data:Object = null):void {
			if(data != null) {
				var action:String = '<%= model_label.pluralize %>';
				var nestedPath:String = '';
				var queryParameters:String = '';
				for each (var parameter:Object in data) {
					for (var nesting:String in parameter) {
						switch(nesting) {
							case 'page':
							case 'filter':
							case 'from':
							case 'to':
								//not happy with using query parameters for filtering
								//it is not RESTful.  TODO: fix
								if(queryParameters != '') { queryParameters += "&"; }
								queryParameters += nesting+'='+parameter[nesting];
								break;
							default:
								if(parameter[nesting] != null && parameter[nesting] != '') {
									nestedPath += '/'+nesting+'/'+parameter[nesting];
								}
								break;
						}
					}
				}
				if(queryParameters != '') { queryParameters = '?'+queryParameters; }
	            ServiceUtils.send(nestedPath+"/"+action+".xml"+queryParameters, _responder);
			} else {
	            ServiceUtils.send("/<%= model_label.pluralize %>.xml", _responder);
			}
        }

		<% unless model_is_read_only %>
		
        public function create<%= model_name %>(<%= model_label.varify %>:<%= model_name %>):void {
/*			Alert.show(<%= model_label.varify %>.toString());*/
            ServiceUtils.send("/<%= model_label.pluralize %>.xml", _responder, "POST",
                <%= model_label.varify %>.toXML(), true);
        }

        public function update<%= model_name %>(<%= model_label.varify %>:<%= model_name %>):void {
            ServiceUtils.send(
                "/<%= model_label.pluralize %>/" + <%= model_label.varify %>.id + ".xml", _responder, "PUT",
                <%= model_label.varify %>.toUpdateObject(), false);
        }

        public function destroy<%= model_name %>(<%= model_label.varify %>:<%= model_name %>):void {
            ServiceUtils.send(
                "/<%= model_label.pluralize %>/" + <%= model_label.varify %>.id + ".xml",
                _responder,
                "DELETE");
        }
		<% end %>
    }
}