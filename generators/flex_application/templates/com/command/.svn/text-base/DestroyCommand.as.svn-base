// This file generated on <%= Date.today %>, by <%= ENV['USER'] %>
// using the Limber plugin via: script/generate flex_application 
package com.<%= file_name %>.command {
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.<%= file_name %>.business.<%= model_name.camelcase %>Delegate;
    import com.<%= file_name %>.control.EventNames;
    import com.<%= file_name %>.model.<%= class_name %>ModelLocator;
    import com.<%= file_name %>.model.<%= model_name.camelcase %>;
    import com.<%= file_name %>.util.CairngormUtils;
    
    import mx.controls.Alert;
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    public class Destroy<%= model_name.camelcase %>Command implements ICommand,
    IResponder {
        public function Destroy<%= model_name.camelcase %>Command() {
        }

        public function execute(event:CairngormEvent):void {
            var delegate:<%= model_name.camelcase %>Delegate = new <%= model_name.camelcase %>Delegate(this);
            delegate.destroy<%= model_name.camelcase %>(event.data);
        }

        public function result(event:Object):void {
            var resultEvent:ResultEvent = ResultEvent(event);
            var model:<%= class_name %>ModelLocator = <%= class_name %>ModelLocator.getInstance();
            if (event.result == "error") {
                Alert.show( "The <%= model_name.titleize.downcase %> was not successfully deleted.", "Error");
            } else {
				<% if model_klass.after_destroy_client_events.empty? %>
                model.remove<%= model_name.camelcase %>( <%= model_name.camelcase %>.fromXML(XML(event.result)));
	            CairngormUtils.dispatchEvent(EventNames.LIST_<%= model_name.pluralize.upcase %>);
				<% else %>
				<% model_klass.after_destroy_client_events.each do |after_destroy_event| %>
				<% STDERR.puts after_destroy_event.inspect %>
	        	<%= after_destroy_event.conditionally_dispatch %>;
				<% end %>
				<% end %>
            }
        }
    
        public function fault(event:Object):void {
            <%= class_name %>.debug("Destroy<%= model_name.camelcase %>Command#fault: " + event);
            Alert.show("The <%= model_name.titleize.downcase %> was not successfully deleted.", "Error");
        }
    }
}