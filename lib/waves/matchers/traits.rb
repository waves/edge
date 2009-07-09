module Waves

  module Matchers

    # @todo Umm.. what all can exist here? --rue
    #
    class Traits
      def initialize(pattern)
        raise ArgumentError, "No traits given!" unless pattern
        @pattern = pattern
      end

      def call( request )
        @pattern.all? do | key, val |
          ( val.is_a? Proc and val.call( request.traits[ key ] ) ) or val === request.traits[ key ]
        end
      end
      
      # Proc-like interface
      #
      def [](request)
        call request
      end
      

    end

  end

end
