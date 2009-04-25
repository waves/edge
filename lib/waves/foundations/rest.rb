require "ostruct"

require "waves/ext/string"
require "waves/resources/mixin"

module Waves
  module Foundations

    module REST

      # Some kind of a malformed resource definition
      #
      class BadDefinition < StandardError; end


      # Applications are formal, rather than ad-hoc Waves apps.
      #
      class Application

        class << self

          # Resources this application is composed of.
          #
          attr_reader :resources

        end

        # Associate mountpoint with a file and a constant.
        #
        def self.at(mountpoint, map)
          file, constant = *map.to_a.first
          constant = constant.to_s.snake_case.to_sym

          @composition << [constant, OpenStruct.new(:file => file, :mountpoint => mountpoint)]
        end

        # Resource composition block.
        #
        # In this block, the Application defines all of the
        # resources it is composed of (and their prefixes or
        # "mountpoints.") The resources themselves are not
        # defined here.
        #
        # The order of composition is stored and used.
        #
        # @see  .at()
        #
        def self.composed_of(&block)
          @composition ||= []
          instance_eval &block

          mounts = const_set :Mounts, Class.new(Waves::Resources::Base)

          # Only construct the Hash here to retain order for .on()s
          @resources ||= {}

          @composition.each {|name, info|
            @resources[name] = info
            mounts.on(true, info.mountpoint) { to name }
          }
        end

        # Construct and possibly override URL for a resource.
        #
        # @todo Support overrides here. --rue
        #
        def self.url_for(resource, pathspec)
          info = Waves.main.resources[resource.name.split(/::/).last.snake_case.to_sym]
          info.mountpoint + pathspec
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
          @pathspec = Application.url_for self, spec
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

        # Application definition block.
        #
        def application(name, &block)
          app = Class.new Application, &block

          if app.resources.nil? or app.resources.empty?
            raise BadDefinition, "No resource composition!"
          end

          Application.const_set name, app
          Waves << app
        end

        # Resource definition block.
        #
        # @todo Must change the Waves.main to *current* app.
        #
        def resource(name, &block)
          mod = if Module === self then self else Object end

          # We must eval this, because the constant really needs
          # to be defined at the point we are running the body
          # code. --rue
          res = mod.const_set name, Class.new(Resource)
          res.instance_eval &block
        end

      end

    end   # REST

  end
end

# We do not play around.
include Waves::Foundations::REST::ConvenienceMethods

