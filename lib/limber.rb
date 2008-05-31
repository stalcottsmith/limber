require 'rubygems'
require 'builder'
require 'rake'

require 'limber/core_ext/string'
require 'limber/core_ext/hash'
require 'limber/core_ext/active_record_base'
require 'limber/core_ext/scaffold_limber_resource'

module Limber
  
  def self.set_app_name(name)
    @@app_name = name
  end
  
  def self.app_name
    raise "app_name not set" unless @@app_name
    @@app_name
  end
  
  
  def self.const_missing(symbol)
    module_eval %{
      class Limber::#{symbol.to_s.camelcase} < Limber::Components::CustomComponent
      end
    }
    return ('Limber::'+symbol.to_s).constantize
  end
  
  module Behavior
  end
  
  class Event
    [:name, :data, :condition].each {|a| attr_writer a ; attr_reader a }
    def initialize(name=nil, data=nil, condition=nil)
      self.name, self.data, self.condition = name, data, condition
    end
    
    def to_s
      "EventNames."+name.to_s.upcase
    end
    
    def dispatch
      "CairngormUtils.dispatchEvent(#{[self, self.data].compact.join(', ')})"
    end
    
    def conditionally_dispatch
      unless condition.nil?
        "if(#{condition}) { #{dispatch} }"
      else
        dispatch
      end
    end
  end
  

end
# 
# puts "load paths:\n"+$:.join("\n")

# Dir.glob('vendor/plugins/limber/behavior/*').each {|b| require b}

require 'limber/behavior/collection'
require 'limber/behavior/collect'
require 'limber/behavior/alert'
require 'limber/behavior/locate'
require 'limber/behavior/event_alert'
require 'limber/behavior/format_currency'
require 'limber/behavior/format_date'
require 'limber/behavior/model_value'
require 'limber/behavior/create'
require 'limber/behavior/update'
require 'limber/behavior/destroy'
require 'limber/behavior/provide_bindable'
require 'limber/behavior/index_of'
require 'limber/behavior/for_each'
require 'limber/behavior/filter_on_boolean_value'
require 'limber/behavior/reorder'
# require 'limber/behavior/destroy_all'

# 
# STDERR.puts "Got Base:" + Limber::Behavior::Base.new(:price_input_panel, :price_change, 1).inspect
# STDERR.puts "Got Destroy:" +Limber::Behavior::Destroy.new(:price_input_panel, :price_change, 1).inspect

require 'limber/components/application'
require 'limber/components/data_grid_for'
require 'limber/components/form_for'
require 'limber/components/create_or_update_buttons_for'
require 'limber/components/filter_combo_box_for'
require 'limber/components/date_range_selector'
