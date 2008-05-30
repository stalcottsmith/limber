// This file generated on <%= Date.today %>, by <%= ENV['USER'] %>
// using the Limber plugin via: script/generate flex_application 
package com.<%= file_name %>.model {
    import com.adobe.cairngorm.model.IModelLocator;
    import com.<%= file_name %>.control.EventNames;
    import com.<%= file_name %>.util.CairngormUtils;
    import com.<%= file_name %>.validators.ServerErrors;
    
    import mx.collections.ArrayCollection;
    import mx.collections.ListCollectionView;
    import mx.formatters.CurrencyFormatter;

    [Bindable]
    public class <%= class_name %>ModelLocator implements IModelLocator {
				
        //
        //Public properties
        //
        public var user:User;

		<% model_names.each do |model| %>
        public var current<%= model.camelcase %>:<%= model.camelcase %>;
        public var <%= model.varify.pluralize %>:ListCollectionView;
		public var <%= model.varify.pluralize %>AndNone:ListCollectionView;
        <% unless read_only_models.include?(model) %>public var <%= model.varify %>IDMap:Object;<% end %>
		<% end %>

        // public var workflowState:int = VIEWING_SPLASH_SCREEN;

		public function resetGlobalApplicationState():void {
			<% model_names.each do |model| %>
			current<%= model.camelcase %> = null;
			<%= model.varify.pluralize %> = null;
			<%= model.varify.pluralize %> = null;
			<% end %>
		}



		<% model_names.each do |model| %>

		<% unless read_only_models.include?(model) %>
		
        public function update<%= model.camelcase %>(<%= model.underscore %>:<%= model.camelcase %>):void {
			if(<%= model.pluralize.varify %> != null) {
	            for (var i:int = 0; i < <%= model.pluralize.varify %>.length; i++) {
	                var ith<%= model.camelcase %>:<%= model.camelcase %> = <%= model.camelcase %>(<%= model.pluralize.varify %>.getItemAt(i));
	                if (ith<%= model.camelcase %>.id == <%= model.underscore %>.id) {
	                    <%= model.pluralize.varify %>.setItemAt(<%= model.underscore %>, i);
	                    break;
	                }
	            }
			}
        }

        public function remove<%= model.camelcase %>(<%= model.varify %>:<%= model.camelcase %>):void {
			if(<%= model.pluralize.varify %> == null) { return; }
            for (var i:int = 0; i < <%= model.pluralize.varify %>.length; i++) {
                var ith<%= model.camelcase %>:<%= model.camelcase %> = <%= model.camelcase %>(<%= model.pluralize.varify %>.getItemAt(i));
                if (ith<%= model.camelcase %>.id == <%= model.varify %>.id) {
					//This code needs to be fixed in the generator
					//so proper belongs_to associations can be used
                    //ith<%= model.camelcase %>.project.remove<%= model.camelcase %>(ith<%= model.camelcase %>);
                    //ith<%= model.camelcase %>.location.remove<%= model.camelcase %>(ith<%= model.camelcase %>);
                    <%= model.pluralize.varify %>.removeItemAt(i);
                    break;
                }
            }
        }

		<% end %>

		<% unless has_many_models.include?(model_classes[model])%>
	    public function set<%= model.pluralize.camelcase %>(list:XMLList):void {
            <% unless read_only_models.include?(model) %><%= model.varify %>IDMap = {};
            <%= model.varify %>IDMap[0] = <%= model.camelcase %>.NONE;<% end %>
            var <%= model.varify.pluralize %>Array:Array = [];
            var item:XML;
            for each (item in list) {
                var <%= model.varify %>:<%= model.camelcase %> = <%= model.camelcase %>.fromXML(item);
                <%= model.varify.pluralize %>Array.push(<%= model.varify %>);<% unless read_only_models.include?(model) %>
                <%= model.varify %>IDMap[<%= model.varify %>.id] = <%= model.varify %>;<% end %>
            }
			var previousFilterFunction:Function = null;
			if(<%= model.varify.pluralize %> != null) {previousFilterFunction = <%= model.varify.pluralize %>.filterFunction;}
            <%= model.varify.pluralize %> = new ArrayCollection(<%= model.varify.pluralize %>Array);
			<%= model.varify.pluralize %>.filterFunction = previousFilterFunction;
			<%= model.varify.pluralize %>.refresh();
			var <%= model.varify.pluralize %>AndNoneArray:Array = <%= model.varify.pluralize %>Array.slice(0);
			<%= model.varify.pluralize %>AndNoneArray.splice(0, 0, <%= model.camelcase %>.NONE);
			<%= model.varify.pluralize %>AndNone =
			    new ArrayCollection(<%= model.varify.pluralize %>AndNoneArray);
        }
		<% else %>
        public function set<%= model.camelcase.pluralize %>(list:XMLList):void {
            <%= model.varify %>IDMap = {};
            <%= model.varify %>IDMap[0] = <%= model.camelcase %>.NONE;
            var <%= model.varify.pluralize %>Array:Array = [];
            var item:XML;
            for each (item in list) {
                var <%= model.varify %>:<%= model.camelcase %> = <%= model.camelcase %>.fromXML(item);
                <%= model.varify.pluralize %>Array.push(<%= model.varify %>);
                <%= model.varify %>IDMap[<%= model.varify %>.id] = <%= model.varify %>;
            }
			var previousFilterFunction:Function = null;
			if(<%= model.varify.pluralize %> != null) {previousFilterFunction = <%= model.varify.pluralize %>.filterFunction;}
            <%= model.varify.pluralize %> = new ArrayCollection(<%= model.varify.pluralize %>Array);
			<%= model.varify.pluralize %>.filterFunction = previousFilterFunction;
			<%= model.varify.pluralize %>.refresh();
            var <%= model.varify.pluralize %>AndNoneArray:Array =
                <%= model.varify.pluralize %>Array.slice(0);
            <%= model.varify.pluralize %>AndNoneArray.splice(0, 0, <%= model.camelcase %>.NONE);
            <%= model.varify.pluralize %>AndNone =
                new ArrayCollection(<%= model.varify.pluralize %>AndNoneArray);
            _got<%= model.camelcase %> = true;
            list<%= model.camelcase.pluralize %>IfMapsPresent();
        }

		public function get<%= model.camelcase %>(<%= model.varify %>ID:int):<%= model.camelcase %> {
            if (<%= model.varify %>IDMap == null) return null;
            return <%= model.varify %>IDMap[<%= model.varify %>ID];
        }

		private var _got<%= model.camelcase %>:Boolean;
		<% end %><% end %>

        //
        //Private utility functions
        //
/*		<% model_names.each do |model| %><% unless has_many_models.include?(model_classes[model]) %>
        private function list<%= model.camelcase.pluralize %>IfMapsPresent():void {
            if (<%= model_classes[model][:model_belongs_to_associations].collect{|a| '_got'+a.name.to_s.camelcase}.join(' && ') %>) {
                CairngormUtils.dispatchEvent(
                    EventNames.LIST_<%= model.pluralize.upcase %>);
            }
        }<% end %><% end %>
*/
        //
        //Singleton stuff
        //
        private static var modelLocator:<%= class_name %>ModelLocator;

        public static function getInstance():<%= class_name %>ModelLocator{
            if (modelLocator == null) {
                modelLocator = new <%= class_name %>ModelLocator();
            }
            return modelLocator;
        }
        
        //The constructor should be private, but this is not
        //possible in ActionScript 3.0. So, throwing an Error if
        //a second <%= class_name %>ModelLocator is created is the best we
        //can do to implement the Singleton pattern.
        public function <%= class_name %>ModelLocator() {
            if (modelLocator != null) {
                throw new Error(
"Only one <%= class_name %>ModelLocator instance may be instantiated.");
            }
			<% has_many_models.each do |has_many_model| %>_got<%= has_many_model[:model_name].pluralize %> = false;
			<% end %>
        }
    }
}