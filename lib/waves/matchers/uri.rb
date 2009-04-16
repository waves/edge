module Waves

  module Matchers

    class URI < Base

      def initialize( options )
        @path = Waves::Matchers::Path.new( options[ :path ] )
        @constraints = { :server => options[ :server ], :scheme => options[ :scheme ] }
      end

      def call( request )
        test(request) and @path.call(request)
      end

    end

  end

end
