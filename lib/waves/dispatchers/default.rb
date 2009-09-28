module Waves

  module Dispatchers

    class Default < Base

      #
      # Takes a Waves::Request and returns a Waves::Response
      #
      
      def safe(request)
        Waves.config.resource.new( request ).process
      end

    end

  end

end
