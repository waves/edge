module Waves

  module Dispatchers

    class Default < Base

      #
      # Takes a Waves::Request and returns a Waves::Response
      #
      
      def safe(request)
        # safeish default
        request.response.content_type =  Waves::MimeTypes[ request.ext ].first || 'text/html'
        result = Waves.config.resource.new( request ).process
        request.response.write( result.to_s ) if request.response.body.empty?
      end

    end

  end

end
