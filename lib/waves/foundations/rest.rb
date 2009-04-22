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

      # Discrete set of methods to include globally.
      #
      module ConvenienceMethods

        # Resource definition block.
        #
        def resource(name, &block)
          res = Class.new REST::Resource, &block
          Object.const_set name, res
        end

      end

    end   # REST

  end
end

# We do not play around.
include Waves::Foundations::REST::ConvenienceMethods

