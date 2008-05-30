module Limber
  module Behavior
    
    class IndexOf < Base
                  
      def initialize(*args)
        super(*args)
        # STDERR.puts self.class.to_s+ ": "+args.slice(1..3).inspect
        @code = args[1]
        @collection = args[2]
        @params = args[3] || {}
        @code_field = @params[:field] || 'code'
        @collection_type = @params[:collection_type]
      end
      
      def action_script_definitions
        unless @collection_type.eql?(:xml)
          # STDERR.puts self.class.to_s + "@code:#{@code} @collection:#{@collection}, @params:#{@params.inspect}"
          return <<-END_AS
            private function index#{@collection.to_s.camelcase}(id:int):int {
              return _model.#{@collection.to_s.varify}.getItemIndex(_model.#{@collection.to_s.singularize.varify}IDMap[id]);
            }
          END_AS
        else
          return <<-END_AS
          private function index#{@collection.to_s.camelcase}(code:String):int {
            var i:int = -1;

            for (var j:String in #{@collection.to_s.varify}.#{@collection.to_s.singularize.varify}) {
              if (#{@collection.to_s.varify}.#{@collection.to_s.singularize.varify}.#{@code_field}[j] == code) {
                i = int(j);
                break;
              }
            }
            return i;
          }
          END_AS
        end
      end
      
      def hook
        "index#{@collection.to_s.camelcase}(#{@code})"
      end
      
    end
  end
end
