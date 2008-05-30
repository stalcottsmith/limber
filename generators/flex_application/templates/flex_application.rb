#
# This filed defines the top level of your application.
#

class <%= file_name.camelcase %> < Limber::Components::Application
  
  has_attributes :height => "100%", :width => "100%"
  
  # tells Limber to look for these components in app/flex/<%= file_name %>
  has_components :progress_popup #, :component2, :component3
  
  # If a Limber component implements a custom_action_script method,
  # the string returned is added to the top of the MXML file in the script
  # definition area.  Ie. Between <script></script> tags along
  # with any automatically generated ActionScript
  # ...
  def custom_action_script
    return <<-END_AS
      import mx.controls.Alert;
      public static function debug(str:String):void {
        /* Alert.show(str); */
      }
    END_AS
  end
  
  # The :to_mxml method is where the magic happens.
  #  - Limber invokes this method to generate the MXML.
  #  - Ruby’s block structure is used to indicate XML containment hierarchy.
  #  - Unrecognized methods are assumed to correspond to ActionScript classes.
  #  - Hash parameters turn into XML attributes.
  #  - Many shortcuts have been implemented to make attributes more readable
  #    and to reduce code size.  Documentation forthcoming...

  def to_mxml
    # non-UI components must go at the top
    fade :id => 'fadeIn', :duration => 100
    style :source => 'com/<%= file_name %>/css/<%= file_name %>.css'
    
    # UI Components
    h_box(:height => "100%", :vertical_align => "center") {
      label :text => "Hello World!", :font_size => 42
    }
  end
  
end