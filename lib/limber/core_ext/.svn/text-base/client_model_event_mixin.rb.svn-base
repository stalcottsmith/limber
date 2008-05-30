module Limber::CoreExt::ClientModelEventMixin

  # This whole module is a bit of a hack which pollutes the model
  # code with view behavior, however, it was expedient to do it this
  # way because the first application I tested and developed this for
  # used a pre-defined database which utilized Views in Oracle.
  #
  # It turned out the views were actually useful.
  #
  # In such a situation it is necessary to refresh a client
  # representation of the view upon create/update/delete
  # of a model which contributes data to the view.  Thus, this can
  # also be seen as expressing a relationship between models.  
  # (This other model is a view of this model.)
  #
  # Ideally this could expressed more simply like:
  #
  #   participates_in_view :my_other_view
  #
  # Which in turn would imply something like this:
  #
  #   on_client :list_my_other_view, :after => [:create, :update, :delete]
  #
  # The end result of this is that the first stage of code generation
  # for the plugin will add the appropriate events to the result handler
  # of the Command class for the appropriate operation on the model.
  #
  # NOTE:  I really tried to do this a different way but it is really
  # difficult to add class methods to a class based on a class method
  # from a module included as a mixin.  My understanding must be
  # incomplete or else it would have been easier.  Instead, good old
  # hashes come to the rescue!
  #
  # It seems class variables using @@ always refer to the outer module
  # context in which you are using them.  It kept overwriting the contents
  # if I invoked the on_client method from another second class, thus
  # forcing all classes using the on_client method into the same behavior.
  #
  
  def self.included(base)
    # STDERR.puts "Limber::CoreExt::ClientModelEventMixin included into #{base.to_s}"
    base.module_eval do

      def self.on_client(evt, args)
        # STDERR.puts "on_client: (#{self.to_s}) #{evt.inspect}, #{args.inspect}"
        events_to_dispatch = evt.is_a?(Array) ? evt : [evt]
        events_to_dispatch = events_to_dispatch.collect do |event_name|
          Limber::Event.new(event_name, args[:with_nested_scope], args[:condition])
        end
        @@events_to_dispatch ||= {}
        @@events_to_dispatch[self] = {}
        args[:after].each do |action|
          @@events_to_dispatch[self][action] = events_to_dispatch
        end

      end
      
      def self.after_create_client_events
        @@events_to_dispatch ||= {}
        @@events_to_dispatch[self] && @@events_to_dispatch[self][:create] ? @@events_to_dispatch[self][:create] : []
      end
      
      def self.after_update_client_events
        @@events_to_dispatch ||= {}
        @@events_to_dispatch[self] && @@events_to_dispatch[self][:update] ? @@events_to_dispatch[self][:update] : []
      end

      def self.after_destroy_client_events
        @@events_to_dispatch ||= {}
        @@events_to_dispatch[self] && @@events_to_dispatch[self][:destroy] ? @@events_to_dispatch[self][:destroy] : []
      end
      
      
    end
  end
end
