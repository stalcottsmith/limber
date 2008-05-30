#
# This filed defines the top level of your application.
#
# Components of this application are defined in the app/flex/<%= file_name %> directory.
#

class <%= file_name.camelcase %> < Limber::Components::Application
  
  has_attributes :height => "100%", :width => "100%"
  
  has_components :progress_popup
  
  def custom_action_script
    
  end
  
  def to_mxml
    label :text => "Hello World!"
  end
  
end