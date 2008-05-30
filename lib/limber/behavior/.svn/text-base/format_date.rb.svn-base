module Limber
  module Behavior
    
    # Format a Date.  TODO: Generalize.
    #
    # Usage:
    #
    #     data_grid_column :label_function => format_date(:start_date)
    #
    class FormatDate < Base
                                    
      def initialize(*args)
        super(*args)
        @symbol = args[1]
        @var_name = @symbol.to_s.varify
        @method_name = "format#{@symbol.to_s.camelcase}"
        
        
        imports << "mx.formatters.DateFormatter"
        imports << "mx.controls.dataGridClasses.DataGridColumn"
        # STDERR.puts imports.inspect
      end
      
      def action_script_definitions
        s = <<-EOF
        private static var #{@var_name}DateTimeFormatter:DateFormatter = new DateFormatter();
        #{@var_name}DateTimeFormatter.formatString = "DD-MMM-YYYY  JJ:NN";
        private static var #{@var_name}DateFormatter:DateFormatter = new DateFormatter();
        #{@var_name}DateFormatter.formatString = "DD-MMM-YYYY";

        private function #{@method_name}(item:Object, column:DataGridColumn):String {
          if (item.#{@var_name} != null ) {
            var formattedDate:String = #{@var_name}DateTimeFormatter.format(item.#{@var_name});
            if( formattedDate == '31-Mar-2020  00:00') {
              return "never";
            } else {
              return formattedDate;
            }                    
          } else {
            return null;
          }
        }
EOF
        return s
      end
      
      def hook
        @method_name
      end
      
    end
  end
end
