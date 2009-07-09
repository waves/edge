module Waves
  module Matchers

    class Ext
      
      def initialize( ext )
        @ext = ext
      end

      def call(request)
        test( request.extension, @ext )
      end
      
      def test( val, pat )
        case pat
        when false then val.nil?
        when true, '.*', val then true
        when Symbol, Symbol then val == ".#{pat}"
        when Array then pat.any? { |e| test( val, e ) }
        end
      end

    end

  end

end
