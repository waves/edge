module Waves
  module Foundations

    module REST

      # Base class to use for resources.
      #
      # Mainly here for simple access to some convenience
      # methods.
      #
      class Resource

        # Viewability definition block
        #
        def self.viewable(&block)
        end

      end

      # Resource definition block.
      #
      def resource(name, &block)
        # Be extra clear
        res = Class.new REST::Resource, &block
        Object.const_set name, res
      end

    end

  end
end

# We do not play around.
include Waves::Foundations::REST

