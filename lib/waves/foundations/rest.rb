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
      # @todo Should maybe insulate the term -> HTTP method
      #       mapping a bit more. --rue
      #
      class Resource
        # @todo Direct include/extend to avoid having to use
        #       Mixin. It is cumbersome to glue in at this
        #       stage. --rue
        include ResponseMixin, Functor::Method
        extend  Resources::Mixin::ClassMethods

        # Creatability definition block (POST)
        #
        # @see  .representation
        #
        def self.creatable(&block)
          raise BadDefinition, "No .url_of_form specified!" unless @pathspec

          @method = :post
          instance_eval &block
        ensure
          @method = nil
        end

        # Representation definition block
        #
        def self.representation(*types, &block)
          # @todo Faking it.
          on(@method, @pathspec, :requested => types) {}
        end

        # URL format specification.
        #
        # The resource defines its own parts, but the app
        # may provide a prefix or even completely override
        # its selection (so long as it can provide all the
        # named captures the resource is expecting, which
        # means that type of override is rare in practice.
        #
        def self.url_of_form(spec)
          @pathspec = Application.make_url_for self, spec
        end

        # Viewability definition block (GET)
        #
        # @see  .representation
        #
        def self.viewable(&block)
          raise BadDefinition, "No .url_of_form specified!" unless @pathspec

          @method = :get
          instance_eval &block
        ensure
          @method = nil
        end
      end

      # Discrete set of methods to include globally.
      #
      module ConvenienceMethods

        # Resource definition block.
        #
        def resource(name, &block)
          Object.const_set name, Class.new(REST::Resource, &block)
        end

      end

    end   # REST

  end
end

# We do not play around.
include Waves::Foundations::REST::ConvenienceMethods

