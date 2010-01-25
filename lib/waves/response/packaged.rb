module Waves
  class Response
    
    class Packaged < Exception
      def self.[]( status )
        Class.new( self ) do 
          define_method( :status ) { status }
        end
      end
      def call( response )
        response.status = status
      end
      def message
        "HTTP Reponse #{status}"
      end
    end
        
  end
end
