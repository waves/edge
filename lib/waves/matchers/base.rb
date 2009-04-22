module Waves
  module Matchers

    class Base

      attr_accessor :constraints

      # Basic matching mechanism.
      #
      # Matchers may override in their #call method, call
      # back into #test() with a subconstraint etc.
      #
      # @todo This could maybe be optimised by detecting
      #       empty constraints before calling. Not high
      #       importance. --rue
      #
      def test(request)
        constraints.all? {|key, val|
          if val.nil? or val == true
            true
          else
            if val.respond_to? :call
              val.call( request )
            else
              val == request.send( key ) or val === request.send( key ) or request.send( key ) === val
            end
          end
        }
      end

      # Convenience for building matchers.
      #
      # Errors from blocks ignored in general.
      #
      # @todo Only ArgumentError? --rue
      #
      def maybe()
        yield
      rescue
        # No need to act
      end

      # Proc-like interface
      #
      # Default--this is usually overridden.
      #
      def call(request)
        test request
      end

      # Proc-like interface
      #
      def [](request)
        call request
      end

    end

  end

end
