#
# This filed defines the top level of your application.
#
# Components of this application are defined in the app/flex/<%= file_name %> directory.
#

class <%= file_name.camelcase %> < Limber::Components::Application
  
  has_attributes :height => "100%", :width => "100%"
  
  has_components :progress_popup
  
  # If this method is defined in your component, the ActionScript is 
  # included at the top of the .mxml file.  The debug() function is
  # necessary only in the top-level Application component.
  def custom_action_script
    return <<-END_AS
      import mx.controls.Alert;
      public static function debug(str:String):void {
        /* Alert.show(str); */
      }
    END_AS
  end
  
  def to_mxml
    label :text => "Hello World!"
  end
  
end