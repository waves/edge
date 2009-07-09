module Waves

  module Matchers

    #
    # todo:
    # hmmm ... it turns out there don't seem to be a whole lot
    # of matchers that aren't request-based. and by "whole lot"
    # i really mean "any" ... so maybe we don't need this extra
    # layer of abstraction? -dan
    #

    class Resource
      
      def initialize( options )
        @matcher = Waves::Matchers::Request.new( options )
      end

      def call( resource ) ; @matcher.call( resource.request ) ; end
      def []( *args ) ; call( *args ) ; end
          
    end
    
  end
  
end