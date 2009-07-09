module Waves

  module Matchers

    # Matcher for the whole URL.
    #
    class URI
      
      attr_accessor :constraints

      def initialize(options)
        
        # Simplest to fake it if there is no path to match
        @path = if options[:path]
          Waves::Matchers::Path.new( options[:path] )
        else 
          lambda { {} }
        end
        
        @constraints = {}

        @constraints[:host] = options[:host] if options[:host]
        @constraints[:port] = options[:port] if options[:port]
        @constraints[:scheme] = options[:scheme] if options[:scheme]

        raise ArgumentError, "No URI matching" if !@path and @constraints.empty?
      end

      # Match resource URL.
      #
      # This returns the set of captures if matching!
      #
      def call(request)
        if captures = @path.call(request) and test(request)
          captures
        end
      end
      
      #
      # @todo This could maybe be optimised by detecting
      #       empty constraints before calling. Not high
      #       importance. --rue
      #
      def test(request)
        constraints.all? {|key, val|
          if val.nil? or val == true
            true
          else
            if val.respond_to? :call
              val.call( request )
            else
              val == request.send( key ) or val === request.send( key ) or request.send( key ) === val
            end
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
