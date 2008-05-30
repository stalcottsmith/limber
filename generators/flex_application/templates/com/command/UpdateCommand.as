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
    
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    public class Update<%= model_name.camelcase %>Command implements ICommand, IResponder {
        public function Update<%= model_name.camelcase %>Command() {
        }

        public function execute(event:CairngormEvent):void {
            var delegate:<%= model_name.camelcase %>Delegate = new <%= model_name.camelcase %>Delegate(this);
            delegate.update<%= model_name.camelcase %>(event.data);
        }

        public function result(event:Object):void {
            var resultEvent:ResultEvent = ResultEvent(event);
            var model:<%= class_name %>ModelLocator = <%= class_name %>ModelLocator.getInstance();
			<% if model_klass.after_update_client_events.empty? %>
            model.update<%= model_name.camelcase %>(<%= model_name.camelcase %>.fromXML(XML(event.result)));
        	CairngormUtils.dispatchEvent(EventNames.LIST_<%= model_name.pluralize.upcase %>);
			<% else %>
			<% model_klass.after_update_client_events.each do |after_update_event| %>
        	<%= after_update_event.conditionally_dispatch %>;
			<% end %>
			<% end %>
        }
    
        public function fault(event:Object):void {
            <%= class_name %>.debug("Update<%= model_name.camelcase %>Command#fault: " + event);
        }
    }
}