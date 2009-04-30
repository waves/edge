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

          # File that this Application is currently loading if any.
          attr_reader   :loading

          # Resources this application is composed of.
          attr_reader   :resources

        end

        # Associate mountpoint with a file path for resource.
        #
        # Path is stored expanded to absolute for matching.
        # You can leave the .rb out if you really like.
        #
        # @see  .look_in
        #
        def self.at(mountpoint, path)
          @composition << [path, mountpoint]
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
        # @see  .at
        # @see  ConvenienceMethods#resource
        #
        def self.composed_of(&block)
          @composition ||= []
          instance_eval &block

          mounts = const_set :Mounts, Class.new(Waves::Resources::Base)

          # Only construct the Hash here to retain order for .on()s
          @resources ||= {}

          @composition.each {|path, mountpoint|
            path = path.to_s.snake_case if Symbol === path

            path << ".rb" unless path =~ /\.rb$/

            found = if @look_in
                      @look_in.find {|prefix|
                        candidate = File.expand_path File.join(prefix, path)
                        break candidate if File.exist? candidate
                      }
                    else
                      path = File.expand_path path
                      path if File.exist?(path)
                    end

            raise ArgumentError, "Path #{path} does not exist!" unless found

            # Resource will register itself when loaded
            @resources[found] = OpenStruct.new  :mountpoint => mountpoint,
                                                :actual => nil

            # This, ladies and gentlemen, is evil.
            mounts.on(true, mountpoint) {
              res = Waves.main.load(found)

              # Replace this for the future
              mounts.on(true, mountpoint) { to res }
              to res
            }
          }
        end

        # Override normal loading to access file being loaded.
        #
        # Used by the first-load hook, see .composed_of.
        # Returns the newly loaded resource.
        #
        def self.load(path)
          @loading = path
          Kernel.load path

          @resources[path].actual

        ensure
          @loading = nil
        end

        # Path prefixes to look for resource files under.
        #
        # Optional trailing /, one or more needed. Each is
        # checked in the order given.
        #
        def self.look_in(*prefixes)
          @look_in = prefixes
        end

        # Allow resource to register itself when loaded.
        #
        # The path-indexed entry is completed with the actual resource
        # and a mirror version is created, indexed by the resource itself.
        #
        # @todo Is there any point trying to add better failure
        #       if the path is unknown? Probably not. --rue
        #
        def self.register(resource)
          entry = @resources[@loading]
          entry.actual = resource

          # Mirror
          @resources[resource] = OpenStruct.new :mountpoint => entry.mountpoint,
                                                :path => @loading
        end

        # Construct and possibly override URL for a resource.
        #
        # @todo This may be obsolete, move to registration? --rue
        #
        def self.url_for(resource)
          info = Waves.main.resources[resource]
          info.mountpoint + resource.needed_from_url
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

        # Introduce new MIME type and its extension(s)
        #
        # This is used to allow resources to differentiate between
        # different kinds of representations (or content types.)
        # For example, a Wiki page resource may introduce a MIME
        # type for an "editable" representation, which then allows
        # producing the appropriate editor interface. The MIME types
        # added thusly should follow the normal semantics, which means
        # that usually they will be of the form "application/vnd.somestring".
        # As an example, the Unspecified MIME type is defined in Waves
        # as "vnd.com.rubywaves.unspecified".
        #
        # The users can communicate the desired MIME type either the
        # correct way of using the Accept header or, commonly with a
        # web browser, by using the extension.
        #
        def self.introduce_mime(type, options)
          exts = Array(options[:exts])
          raise ArgumentError, "Must give file extensions for MIME!" if exts.empty?

          Waves::MimeExts[type] += exts
          Waves::MimeExts[type].uniq!

          exts.each {|ext|
            Waves::MimeTypes[ext] << type
            Waves::MimeTypes[ext].uniq!
          }
        end

        # The bits we need from an URL.
        #
        # Essentially just exposes the pathspec given in .url_of_form.
        #
        def self.needed_from_url()
          @needed_from_url
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
          @needed_from_url = spec
          @pathspec = Application.url_for self
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

          mod = if Module === self then self else Object end
          mod.const_set name, app

          Waves << app
        end

        # Resource definition block.
        #
        # @todo Must change the Waves.main to *current* app. --rue
        #
        def resource(name, &block)
          mod = if Module === self then self else Object end

          res = mod.const_set name, Class.new(Resource)

          Waves.main.register res

          # We must eval this, because the constant really needs
          # to be defined at the point we are running the body
          # code. --rue
          res.instance_eval &block
        end

      end

    end   # REST

  end
end

# We do not play around.
include Waves::Foundations::REST::ConvenienceMethods

