require "waves/resources/mixin"

module Waves
  module Foundations

    module REST

      # Base class to use for resources.
      #
      # Mainly here for simple access to some convenience
      # methods.
      #
      class Resource
        # @todo Direct include/extend to avoid having to use
        #       Mixin. It is cumbersome to glue in at this
        #       stage. --rue
        include ResponseMixin, Functor::Method
        extend  Resources::Mixin::ClassMethods

        # Viewability definition block
        #
        # @see  .representation
        #
        def self.viewable(&block)
          instance_eval &block
        end

        # Representation definition block
        #
        def self.representation(*types, &block)
          # @todo Faking it.
          on(:get, true, :accept => types) {}
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

