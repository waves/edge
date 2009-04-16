module Waves

  module Matchers

    # @todo Rename to Negotiation? --rue
    #
    class Accept < Base

      # Set up Accept parsing.
      #
      # Only the defined constraints are included.
      #
      def initialize(options)
        @constraints = {}

        # Default to accepting text/html
        if options[:accept] and !options[:accept].empty?
          @constraints[:accept] = options[:accept]
        end

        if options[:charset] and !options[:charset].empty?
          @constraints[:accept_charset] = options[:charset]
        end

        if options[:lang] and !options[:lang].empty?
          @constraints[:accept_language] = options[:lang]
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
