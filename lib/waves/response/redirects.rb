module Waves
  class Response

    module Redirect ; end

    # Redirects are raised by applications and rescued by the Waves 
    # dispatcher and used to set the response status and location.

    module Redirects
      
      class Found < Packaged[302]
        include Redirect
        attr_reader :location
        def initialize( location )
          @location = location ; super()
        end
        def call( response )
          response.location = location
          super( response )
        end
      end
    
      class NotModified < Packaged[304]
        include Redirect
        def call ( response )
          %w( Allow Content-Encoding Content-Language Content-Length Content-MD5
                Content-Type Last-Modified ).each { |h| response.headers.delete( h ) }
          response.cache_control = 'public'
          response.body = []
          super( response )
        end
      end
    end
  end
end