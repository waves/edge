module Waves
  module Matchers

    class Request

      attr_accessor :constraints


      #
      # @todo Further optimise the cases where there are no
      #       constraints. --rue
      #

      def initialize(options)
        
        @uri = Matchers::URI.new( options )

        @constraints = {}

        if options[ :requested ]
          @constraints[ :requested ] = Matchers::Requested.new( options[ :requested ] )
        end
        
        if options.key?( :accept ) || options.key?( :lang ) || options.key?( :charset )
          @constraints[:accept] = Matchers::Accept.new( options ) 
        end
        
        if options.key?( :ext )
          @constraints[ :ext ] = Matchers::Ext.new(  options[ :ext ] )
        elsif options.key?( :extension )
          @constraints[ :ext ] = Matchers::Ext.new(  options[ :extension ] )
        end
        
        if options.key?( :query )
          @constraints[:query] = Matchers::Query.new( options[:query] ) 
        end
          
        if options[ :traits ]
          @constraints[ :traits ] = Matchers::Traits.new( options[ :traits ] )
        end
          
        if options[ :when ]
          @constraints[ :when ] = options[ :when ]
        end
        
      end

      # Process all matchers for request.
      #
      def call(request)
        if captured = @uri.call(request) and test(request)
          request.traits.waves.captured = captured
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
