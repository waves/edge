module Waves

  module Matchers

    class URI < Base
      def initialize(options)
        # Simplest to fake it if there is no path to match
        @path = Waves::Matchers::Path.new(options[:path]) rescue lambda { {} }
        @constraints = {}

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
