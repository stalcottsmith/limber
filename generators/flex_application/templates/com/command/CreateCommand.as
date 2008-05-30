// This file generated on <%= Date.today %>, by <%= ENV['USER'] %>
// using the Limber plugin via: script/generate flex_application 
package com.<%= file_name %>.command {
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.<%= file_name %>.business.<%= model_name.camelcase %>Delegate;
    import com.<%= file_name %>.control.EventNames;
    import com.<%= file_name %>.model.<%= class_name %>ModelLocator;
    import com.<%= file_name %>.util.CairngormUtils;
    
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    public class Create<%= model_name.camelcase %>Command implements ICommand, IResponder {
        public function Create<%= model_name.camelcase %>Command() {}

        public function execute(event:CairngormEvent):void {
            var delegate:<%= model_name.camelcase %>Delegate = new <%= model_name.camelcase %>Delegate(this);
            delegate.create<%= model_name.camelcase %>(event.data);
        }

        public function result(event:Object):void {
            var model:<%= class_name %>ModelLocator = <%= class_name %>ModelLocator.getInstance();
			<% if model_klass.after_create_client_events.empty? %>
            CairngormUtils.dispatchEvent(EventNames.LIST_<%= model_name.pluralize.upcase %>);
			<% else %>
			<% model_klass.after_create_client_events.each do |after_create_event| %>
        	<%= after_create_event.conditionally_dispatch %>;
			<% end %>
			<% end %>
        }
    
        public function fault(event:Object):void {
            <%= class_name %>.debug("Create<%= model_name.camelcase %>Command#fault: " + event);
        }
    }
}