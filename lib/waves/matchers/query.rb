module Waves

  module Matchers

    # Query parameter matching.
    #
    class Query

      # Create query matcher or fail.
      #
      # @todo Should map Symbols to Strings here. --rue
      #
      def initialize(pattern)
        raise ArgumentError, "No Query constraints!" unless pattern
        @pattern = pattern
      end

      # Match query parameters.
      #
      def call(request)
        @pattern.all? {|key, val|
          # @todo Is this right? I do not see how even a
          #       Proc would be useful just given nil from
          #       a nonexisting key. We just fail in those
          #       cases for now. --rue
          if given = request.query[key.to_s]
            val == true or val === given or (val.call(given) rescue false)
          end
        }
      end
      
      # Proc-like interface
      #
      def [](request)
        call request
      end
      

    end

  end

end
