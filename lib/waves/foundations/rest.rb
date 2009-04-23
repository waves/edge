require "waves/resources/mixin"

module Waves
  module Foundations

    module REST

      # Some kind of a malformed resource definition
      #
      class BadDefinition < ::Exception; end


      # Applications are formal, rather than ad-hoc Waves apps.
      #
      class Application
        # Construct and possibly override URL for a resource.
        #
        def self.make_url_for(resource, urlspec)
          urlspec
        end
      end

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

        # Representation definition block
        #
        def self.representation(*types, &block)
          # @todo Faking it.
          on(:get, true, :requested => types) {}
        end

        # URL format specification.
        #
        # The resource defines its own parts, but the app
        # may provide a prefix or even completely override
        # its selection (so long as it can provide all the
        # named captures the resource is expecting, which
        # means that type of override is rare in practice.
        #
        def self.url_of_form(*args)
          @url = Array(args)
        end

        # Viewability definition block
        #
        # @see  .representation
        #
        def self.viewable(&block)
          raise BadDefinition, "No .url_of_form specified!" unless @url
          instance_eval &block
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

