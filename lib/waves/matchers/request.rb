module Waves
  module Matchers

    # Top-level matcher nesting all others.
    #
    class Request < Base

      # Create the top nested set of matchers.
      #
      # @todo Further optimise the cases where there are no
      #       constraints. --rue
      #
      def initialize(options)
        # Simplest to fake it if there is no URL to match
        @uri = Matchers::URI.new(options) rescue lambda { {} }

        @constraints = {}

        # Any of these may or may not be present
        maybe { @constraints[:requested] = Matchers::Requested.new options }
        maybe { @constraints[:accept] = Matchers::Accept.new options }
        maybe { @constraints[:ext] = Matchers::Ext.new options[:ext] }
        maybe { @constraints[:query] = Matchers::Query.new options[:query] }
        maybe { @constraints[:traits] = Matchers::Traits.new options[:traits] }
      end

      # Process all matchers for request.
      #
      def call(request)
        if captured = @uri.call(request) and test(request)
          request.traits.waves.captured = captured
        end
      end

    end

  end

end
