module Limber
  module Behavior
    
    # Format a USD Currency.  TODO: Generalize.
    #
    # Usage:
    #
    #     data_grid_column :label_function => format_curency(:price, {:precision => 3})
    #
    class FormatCurrency < Base
                  
      DEFAULT_OPTIONS = { :id => "usdFormatter", :precision => "2",
                          :currencySymbol => "$", :decimalSeparatorFrom => ".",
                          :decimal_separator_to => ".", :use_negative_sign => "true", 
                          :use_thousands_separator => "true", :align_symbol => "left"}            
                  
      def initialize(*args)
        super(*args)
        @symbol = args[1]
        @options = args[2].nil? ? DEFAULT_OPTIONS : args[2].merge(DEFAULT_OPTIONS)
        @var_name = @symbol.to_s.varify
        @method_name = "format#{@symbol.to_s.camelcase}"
        @formatter = "#{@var_name}Formatter"
        
        
        imports << "mx.formatters.CurrencyFormatter"
        imports << "mx.controls.dataGridClasses.DataGridColumn"
        imports << "com.#{app_name.underscore}.model.#{app_name}ModelLocator"
        # STDERR.puts imports.inspect
      end
      
      def action_script_definitions
        s = "\n\n        public static var #{@formatter}:CurrencyFormatter = new CurrencyFormatter();\n"
        @options.keys.reject {|k| k.eql?(:id)}.each do |key|
          s << "        #{@formatter}.#{key.to_s.varify} = #{quote_immediate(@options[key])};\n"
        end
        s << <<-END
        
        private function #{@method_name}(item:Object, column:DataGridColumn):String {
          if (item.#{@var_name} != null && item.#{@var_name} != 0.0) {
            return #{@formatter}.format(Number(item.#{@var_name}));
          } else {
            return null;
          }
        }
END
      end
      
      def hook
        @method_name
      end
      
    end
  end
end
