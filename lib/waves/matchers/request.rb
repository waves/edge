module Waves

  module Matchers

    class Request < Base

      def initialize(options)
        @uri = Matchers::URI.new(options)

        @constraints = {
          :query => Matchers::Query.new( options[:query] ),
          :traits => Matchers::Traits.new( options[:traits] )
        }

        @constraints[:accept] = Matchers::Accept.new(options) rescue nil
      end

      def call( request )
        if test( request ) and captured = @uri.call(request)
          request.traits.waves.captured = captured
        end
      end

    end

  end

end
