module Waves

  module Resources

    StatusCodes = {
      Waves::Dispatchers::NotFoundError => 404
    }


    module Mixin

      attr_reader :request

      module ClassMethods

        def paths
          unless @paths
            resource = self
            @paths = Class.new( superclass.respond_to?( :paths ) ? superclass.paths : Waves::Resources::Paths ) do
              @resource = resource
              def self.resource ; @resource ; end
            end
          else
            @paths
          end
        end
        def with( options ) ; @options = options ; yield ; @options = nil ; end
        def on( method, path = true, options = nil, &block )
          if path.is_a? Hash
            generator = path.keys.first
            path = path.values.first
          end
          if options
            options[ :path ] = path
          else
            options = { :path => path }
          end
          options = @options.merge( options ) if @options
          matcher = Waves::Matchers::Resource.new( options )
          methods = case method
            when nil then nil
            when true then [ :post, :get, :put, :delete ]
            when Array then method
            else [ method ]
          end
          methods.each do | method |
            functor_with_self( method, matcher, &block )
          end
          paths.module_eval {
            define_method( generator ) { | *args | generate( path, args ) }
          } if generator
        end
        def before( path = nil, options = {}, &block )
          on( :before, path, options, &block )
        end
        def after( path = nil, options = {}, &block )
          on( :after, path, options, &block )
        end
        def wrap( path = nil, options = {}, &block )
          before( path, options, &block )
          after( path, options, &block )
        end
        def handler( exception, &block ) ; functor( :handler, exception, &block ) ; end
        def always( &block ) ; define_method( :always, &block ) ; end

      end

      # this is necessary because you can't define functors within a module because the functor attempts
      # to incorporate the superclass functor table into it's own
      def self.included( resource )

        resource.module_eval do

          include ResponseMixin, Functor::Method ; extend ClassMethods

          def initialize( request ); @request = request ; end

          # define defaults for all the functors, providing the analog
          # of "not implemented" behaviors. this avoids complicating
          # the error handling with having to distinguish between
          # functor match-related errors and actual application errors
          
          # by default, don't do anything in the wrapper methods
          before {} ; after {} ; always {}

          # if we get here, this is a 404
          %w( post get put delete head ).each do | method |
            on( method ) { not_found }
          end
          
          # default handler is just to propagate the exception
          handler( Exception ) { |e| raise( e ) }

          def process
            begin
              before ;  rval = send( request.method ) ; after
            rescue => e
              response.status = ( StatusCodes[ e.class ] || 500 )
              rval = handler( e )
            ensure
              always
            end
            # note: the dispatcher decides what to do with the
            # return value; all we care about is returning the
            # value from the appropriate application block
            return rval
          end

          def to( resource )
            resource = case resource
            when Base
              resource
            when Symbol, String
              Waves.main::Resources[ resource ]
            end
            r = traits.waves.resource = resource.new( request )
            r.process
          end

          def redirect( path ) ; request.redirect( path ) ; end

          # override for resources that may have long-running requests. this helps servers
          # determine how to handle the request
          def deferred? ; false ; end

        end

      end

    end

    class Base ; include Mixin ; end

  end


end
