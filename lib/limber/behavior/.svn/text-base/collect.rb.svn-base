module Limber
  module Behavior
    
    class Collect < Base
                  
      def initialize(*args)
        super(*args)
        throw "must supply array" unless args && args[1].is_a?(Array)
        @array = args[1]
        
        imports << "mx.collections.ArrayCollection"
      end
            
      def hook
        "new ArrayCollection([#{@array.join(', ')}])"
      end
      
    end
  end
end
