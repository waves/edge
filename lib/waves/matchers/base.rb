module Waves
  module Matchers

    class Base

      attr_accessor :constraints

      # Basic matching mechanism.
      #
      # Matchers may override in their #call method, call
      # back into #test() with a subconstraint etc.

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
