// This file generated on <%= Date.today %>, by <%= ENV['USER'] %>
// using the Limber plugin via: script/generate flex_application 
package com.<%= file_name %>.control {
    import com.adobe.cairngorm.control.FrontController;
    import com.<%= file_name %>.control.EventNames;
    import com.<%= file_name %>.command.*;

    public class <%= class_name %>Controller extends FrontController {
        public function <%= class_name %>Controller() {
            initializeCommands();
        }
        
        private function initializeCommands():void {
			<% model_names.each do |model_name| %>addCommand(EventNames.LIST_<%= model_name.underscore.pluralize.upcase %>, List<%= model_name.pluralize.camelcase %>Command);
            <% end %>
			<% (model_names-read_only_models).each do |model_name| %>addCommand(EventNames.CREATE_<%= model_name.underscore.upcase %>, Create<%= model_name.camelcase %>Command);
            <% end %>
			<% (model_names-read_only_models).each do |model_name| %>addCommand(EventNames.DESTROY_<%= model_name.underscore.upcase %>, Destroy<%= model_name.camelcase %>Command);
            <% end %>
			<% (model_names-read_only_models).each do |model_name| %>addCommand(EventNames.UPDATE_<%= model_name.underscore.upcase %>, Update<%= model_name.camelcase %>Command);
            <% end %>

            addCommand(EventNames.CREATE_SESSION, CreateSessionCommand);
            addCommand(EventNames.DESTROY_SESSION, DestroySessionCommand);
/*            addCommand(EventNames.SHOW_NOTE, ShowNoteCommand);
            addCommand(EventNames.LOAD_URL, LoadURLCommand);*/
        }
    }
}