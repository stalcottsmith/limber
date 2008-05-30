// This file generated on <%= Date.today %>, by <%= ENV['USER'] %>
// using the Limber plugin via: script/generate flex_application 
package com.<%= file_name %>.control {
    public final class EventNames {
		<% model_names.each do |model_name| %>public static const LIST_<%= model_name.underscore.pluralize.upcase %>:String = "list<%= model_name.camelcase.pluralize %>";
        <% end %>
		<% (model_names-read_only_models).each do |model_name| %>public static const CREATE_<%= model_name.underscore.upcase %>:String = "create<%= model_name.camelcase %>";
        <% end %>
		<% (model_names-read_only_models).each do |model_name| %>public static const DESTROY_<%= model_name.underscore.upcase %>:String = "destroy<%= model_name.camelcase %>";
        <% end %>
		<% (model_names-read_only_models).each do |model_name| %>public static const UPDATE_<%= model_name.underscore.upcase %>:String = "update<%= model_name.camelcase %>";
        <% end %>
    
        public static const SHOW_NOTE:String = "showNote";
        public static const LOAD_URL:String = "loadURL";
        public static const CREATE_SESSION:String = "createSession";
        public static const DESTROY_SESSION:String = "destroySession";

    }
}