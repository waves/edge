module Waves

  module Matchers

    # Matcher for the whole URL.
    #
    class URI < Base
      def initialize(options)
        # Simplest to fake it if there is no path to match
        @path = Waves::Matchers::Path.new(options[:path]) rescue lambda { {} }
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

    end

  end

end
