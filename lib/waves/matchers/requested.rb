require "waves/matchers/base"

module Waves
  module Matchers

    #
    class Requested < Base

      # Set up Requested parsing.
      #
      # Only the defined constraints are included.
      #
      def initialize(options)
        @constraints = {}

        # Default to accepting text/html
        if options[:requested] and !options[:requested].empty?
          @constraints[:requested] = options[:requested]
        end

        raise ArgumentError, "No Accept constraints!" if @constraints.empty?
      end

      # Verify that any and all Accept constraints match.
      #
      # Request handles these.
      #
      def call(request)
        @constraints.all? {|key, val|
          request.send(key).include? val
        }
      end

    end

  end

end
