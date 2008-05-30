class <%= file_name.camelcase %>::ProgressPopup < Limber::Panel
  
  has_attributes :title => "Status", :width => "350",
                 :background_alpha => 0.75
  
  def to_mxml
    h_box(:padding => 5) {
      image( :source => "@Embed('/com/vmi/assets/bacardi_logo_40x40.png')")
      v_box {
        spacer :height => 8
        progress_bar "Working", :width => "100%", :label_placement => "left", :mode => "manual"
      }
    }
  end

end