require "waves/matchers/base"

module Waves
  module Matchers

    # Combinatory matcher for accept and extension.
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

        if options[:charset] and !options[:charset].empty?
          @constraints[:accept_charset] = options[:charset]
        end

        if options[:lang] and !options[:lang].empty?
          @constraints[:accept_language] = options[:lang]
        end

        raise ArgumentError, "No Requested constraints!" if @constraints.empty?
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
