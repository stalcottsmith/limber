// This file generated on <%= Date.today %>, by <%= ENV['USER'] %>
// using the Limber plugin via: script/generate flex_application 
package com.<%= file_name %>.model {
	<% if model_has_many_associations.size > 0 %>import mx.collections.ArrayCollection;
    <% end %>import com.<%= file_name %>.util.XMLUtils;
	import com.greenfish.util.DateUtils;
    
    public class <%= model_name %> {
        public static const UNSAVED_ID:int = 0;
        public static const NONE_ID:int = 0;
		<% none_values = (model_attributes.collect {|a| a.name.eql?('name') ? '"- None -"' : ASType.defaults(a.klass.to_s) } +
		 				 model_belongs_to_associations.collect {|a| ASType.defaults(a.class_name) }) %>
        public static const NONE: <%= model_name %> =
            new <%= model_name %>(<%= none_values.join(', ') %>);
/*
		[Bindable]
		public var id:int;*/
		<% model_attributes.each do |attribute| %>
		[Bindable]
		public var <%= attribute.name.varify %>:<%= ASType.mappings(attribute.klass.to_s) %>;
		<% end %><% model_belongs_to_associations.each do |association| %>
		[Bindable]
		public var <%= association.name.to_s.varify %>:<%= ASType.mappings(association.class_name) %>;
		<% end %><% model_has_many_associations.each do |has_many| %>
		[Bindable]
		public var <%= has_many.name.to_s.varify %>: ArrayCollection;
		<% end %>

        public function <%= model_name %>(
			<%= (model_attributes.collect { |attribute| '			'+attribute.name.varify+':'+
					(ASType.should_parse?(attribute.klass.to_s) ? 'String' : ASType.mappings(attribute.klass.to_s)).to_s+
					' = '+ ASType.defaults(attribute.klass.to_s).to_s } +
			    model_belongs_to_associations.collect { |association| '			'+association.name.to_s.varify+':'+
							ASType.mappings(association.class_name).to_s+' = '+ASType.defaults(association.class_name).to_s
				}).join(",\n") %>)
        {
            <% model_attributes.each do |attribute| %>this.<%= attribute.name.varify %> = <%= ASType.parse(attribute.klass.to_s, attribute.name.varify) %>;
			<% end %><% model_belongs_to_associations.each do |association| %>
			if (<%= association.name.to_s.varify %> == null) {
				<%= association.name.to_s.varify %> = <%= association.name.to_s.camelcase %>.NONE
			}
			<% if association.klass.reflect_on_all_associations.select do |a| 
					a.klass == model_name.constantize && a.name = model_name.underscore 
			   end.size > 0 %>
			<%= association.name.to_s.varify %>.set<%= model_name %>(this);<% end %>
			<% end %>
        }

		public function toString():String {
			var s:String = "<%= model_name %> {"<% model_attributes.each do |a| %>
			<% if ASType.should_parse?(a.klass.to_s) %>s += "<%= a.name.varify %> = "+(<%= a.name.varify %> != null ? <%= a.name.varify %>.toString() : 'null') +' ';<% else %>s += "<%= a.name.varify %> = "+ <%= a.name.varify %>.toString()+' ';<% end %><% end %>
			return s; 
		}

		<% model_has_many_associations.each do |has_many| %>

        public function add<%= has_many.name.to_s.singularize.camelcase %>(<%= has_many.name.to_s.singularize %>:<%= has_many.class_name %>):void {
            <%= has_many.name.to_s.singularize %>.<%= model_label %> = this;
            <%= has_many.name %>.addItem(<%= has_many.name.to_s.singularize %>);
        }

        public function remove<%= has_many.name.to_s.singularize.camelcase %>(<%= has_many.name.to_s.singularize %>:<%= has_many.class_name %>):void {
            if (<%= has_many.name.to_s.singularize %>.<%= model_label %> == this) {
                for (var i:int = 0; i < <%= has_many.name %>.length; i++) {
                    if (<%= has_many.name %>[i].id == <%= has_many.name.to_s.singularize %>.id) {
                        <%= has_many.name %>.removeItemAt(i);
                        <%= has_many.name.to_s.singularize %>.<%= model_label %> = null;
                        break;
                    }
                }
            }
        }

        <% end %>
		<% model_has_one_associations.each do |has_one| %>

        public function add<%= has_one.name.to_s.singularize.camelcase %>(<%= has_one.name.to_s %>:<%= has_one.class_name %>):void {
            <%= has_one.name.to_s %>.<%= model_label %> = this;
            this.<%= has_one.name.to_s %> = <%= has_one.name.to_s %>;
        }

        public function remove<%= has_one.name.to_s.singularize.camelcase %>(<%= has_one.name.to_s.singularize %>:<%= has_one.class_name %>):void {
            <%= has_one.name.to_s %>.<%= model_label %> = null;
            this.<%= has_one.name.to_s %> = null;
        }

        <% end %>
        public function toUpdateObject():Object {
            var obj:Object = new Object();
			<% model_attributes.each do |attribute| %>obj["<%= model_label %>[<%= attribute.name %>]"] = <%= attribute.name.varify %>;
			<% end %><% model_belongs_to_associations.each do |association| %>obj["<%= model_label %>[<%= association.name.to_s %>_id]"] = <%= association.name.to_s.varify %>.id;
            <% end %>return obj;
        }
        
        public function toXML():XML {
            var retval:XML =
	            <<%= model_label %>>
					<% model_attributes.each do |attribute| %><<%= attribute.name %>>{<%= attribute.name.varify %>}</<%= attribute.name %>>
					<% end %><% model_belongs_to_associations.each_with_index do |association,index| %><<%= association.name.to_s %>_id>{<%= association.name.to_s.varify %>.id}</<%= association.name.to_s %>_id><%= model_belongs_to_associations.size-1 > index ? "\n\t\t\t\t\t" : "\n\t\t\t\t"%><% end %></<%= model_label %>>;
            return retval;
        }
        
        public static function fromXML(<%= model_label %>XML:XML):<%= model_name %> {
            var model:<%= class_name %>ModelLocator =
                <%= class_name %>ModelLocator.getInstance();
            return new <%= model_name %>(
                <%= (model_attributes.collect { |attribute| tranlate_boolean = ASType.mappings(attribute.klass.to_s) == 'Boolean'
															'                '+(tranlate_boolean ? 'XMLUtils.xmlListToBoolean(' : '')+model_label+"XML."+attribute.name+ (tranlate_boolean ? ')' : '') } + 
				 	 model_belongs_to_associations.collect { |association| 'null' }).join(", \n") %>);
        }
    }
}