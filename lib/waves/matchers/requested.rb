require "waves/matchers/base"

module Waves
  module Matchers

    #
    # Matches the MIME-type of the URI path (using the extension)
    # and, failing that, falls back to the accept header
    #
    # Use :extension or :ext for matching the extension itself or
    # :accept to match the actual HTTP Accept header
    #
    
    class Requested

      def initialize( val ) ; @val = val ; end
      
      def call( request )
        request.requested.include?( @val )
      end

      # Proc-like interface
      #
      def [](request)
        call request
      end
      

    end

  end

end
