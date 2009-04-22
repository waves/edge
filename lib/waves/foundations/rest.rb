module Waves
  module Foundations

    module REST

      class Resource
      end

      # Resource definition block.
      #
      def resource(name, &block)
        res = Class.new &block
        Object.const_set name, res
      end

    end

  end
end

# We do not play around.
include Waves::Foundations::REST

