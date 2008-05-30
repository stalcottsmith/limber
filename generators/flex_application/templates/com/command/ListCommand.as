// This file generated on <%= Date.today %>, by <%= ENV['USER'] %>
// using the Limber plugin via: script/generate flex_application 
package com.<%= file_name %>.command {
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.<%= file_name %>.business.<%= model_name.camelcase %>Delegate;
    import com.<%= file_name %>.model.<%= class_name %>ModelLocator;
    
    import mx.controls.Alert;
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    public class List<%= model_name.pluralize.camelcase %>Command implements ICommand,
    IResponder {
        public function List<%= model_name.pluralize.camelcase %>Command() {     
        }

        public function execute(event:CairngormEvent):void {
            var delegate:<%= model_name.camelcase %>Delegate = new <%= model_name.camelcase %>Delegate(this);
            delegate.list<%= model_name.pluralize.camelcase %>(event.data);
        }

        public function result(event:Object):void {
            var model:<%= class_name %>ModelLocator = <%= class_name %>ModelLocator.getInstance();
            model.set<%= model_name.pluralize.camelcase %>(XMLList(event.result.children()));
        }
    
        public function fault(event:Object):void {
            <%= class_name %>.debug("List<%= model_name.camelcase %>sCommand#fault: " + event);
            Alert.show("<%= model_name.pluralize.titleize %> could not be retrieved!");
        }
    }
}