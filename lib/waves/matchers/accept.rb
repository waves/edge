module Waves
  module Matchers

    # @todo Rename to Negotiation? --rue
    #
    class Accept

      # Set up Accept parsing.
      #
      # Only the defined constraints are included.
      #
      def initialize(options)
        
        @constraints = {}
        
        { :accept => :accept, :charset => :accept_charset, :lang => :accept_lang }.each { |key,method|
          if options[key]
            if options[key].is_a? Array
              @constraints[method] = options[key] unless options[key].empty?
            else
              @constraints[method] = [ options[key] ]
            end
          end
        }
        
      end

      # Verify that any and all Accept constraints match.
      #
      # Request handles these.
      #
      def call(request)
        @constraints.all? { |key, val| request.send(key).include? val }
      end
      
      # Proc-like interface
      #
      def [](request)
        call request
      end
      

    end

  end

end
