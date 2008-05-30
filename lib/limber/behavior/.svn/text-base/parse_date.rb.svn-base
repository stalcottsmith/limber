module Limber
  module Behavior
    class ParseDate < Base
                                    
      def initialize(*args)
        super(*args)
        @string_to_parse = args[1]
        
        imports << "com.greenfish.util.DateUtils"
      end
      
      
      def hook
        "{DateUtils.toASDate(#{@string_to_parse})}"
      end
      
    end
  end
end
