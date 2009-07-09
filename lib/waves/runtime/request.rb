module Waves

  # Waves::Request represents an HTTP request and provides convenient methods for accessing request attributes.
  # See Rack::Request for documentation of any method not defined here.

  class Request

    class ParseError < Exception ; end

    class Query ; include Attributes ; end

    attr_reader :response, :session, :traits

    # Create a new request. Takes a env parameter representing the request passed in from Rack.
    # You shouldn't need to call this directly.
    #
    def initialize(env)
      @traits = Class.new { include Attributes }.new( :waves => {} )
      @request = Rack::Request.new(env).freeze
      @response = Waves::Response.new self
      @session = Waves::Session.new self
    end

    # Rack request object.
    #
    def rack_request()
      @request
    end

    # Methods delegated directly to rack
    %w( url scheme host port body query_string content_type media_type content_length referer ).each do |m|
      define_method( m ) { @request.send( m ) }
    end

    # The request path (PATH_INFO). Ex: +/entry/2008-01-17+
    def path ; @request.path_info ; end

    # Access to "params" - aka the query string - as a hash
    def query ; @request.params ; end

    alias_method :params, :query
    alias_method :domain, :host

    # Request method predicates, defined in terms of #method.
    %w{get post put delete head options trace}.
      each { |m| define_method( m ) { method.to_s == m } }

    # The request method. Because browsers can't send PUT or DELETE
    # requests this can be simulated by sending a POST with a hidden
    # field named '_method' and a value with 'PUT' or 'DELETE'. Also
    # accepted is when a query parameter named '_method' is provided.
    def method
      @method ||= ( ( ( m = @request.request_method.downcase ) == 'post' and
        ( n = @request['_method'] ) ) ? n.downcase : m ).intern
    end

    def []( key ) ; @request.env[ key.to_s.upcase ] ; end

    # access HTTP headers as methods
    def method_missing( name, *args, &body )
      if args.empty? and not body
        cache_method_missing name, <<-CODE, *args, &body
          key = "HTTP_#{name.to_s.upcase}"
          @request.env[ key ] if @request.env.has_key?( key )
        CODE
      else
        super
      end
    end


    # Raise a not found exception.
    def not_found
      raise Waves::Dispatchers::NotFoundError, "#{@request.url} not found."
    end

    # Issue a redirect for the given path.
    def redirect( path, status = '302' )
      raise Waves::Dispatchers::Redirect.new( path, status )
    end


    # Requested representation MIME type
    def accept()
      @accept ||= Accept.parse(@request.env['HTTP_ACCEPT'])
    end

    # Combination of Accept and file extension for matching.
    #
    # A file extension takes precedence over the Accept
    # header, the Accept is ignored.
    #
    # The absence of a file extension is indicated using
    # the special MIME type MimeTypes::Unspecified, which
    # allows specialised handling thereof. The resource
    # must specifically accept Unspecified for it to have
    # an effect.
    #
    # @see  matchers/requested.rb
    # @see  #accept
    # @see  #ext
    # @see  runtime/mime_types.rb for the actual definition
    #       of the Unspecified type.
    #
    def requested()
      return @requested if @requested
      if ext
        @requested = Accept[*MimeTypes[ext]]
        return @requested
      end

      # This needs to be an Accept < Array
      @requested = accept.unshift Mime::Unspecified
    end

    # Requested charset(s).
    #
    # @see  matchers/accept.rb
    #
    def accept_charset()
      @charset ||= Accept.parse(@request.env['HTTP_ACCEPT_CHARSET'])
    end

    # Requested language(s).
    #
    # @see  matchers/accept.rb
    #
    def accept_language()
      @lang ||= Accept.parse(@request.env['HTTP_ACCEPT_LANGUAGE'])
    end

    # File extension, with leading dot.
    #
    # Usable for MIME lookups too.
    #
    # @todo Drop the leading dot?
    #
    def ext()
      return @ext if @ext

      e = File.extname path

      @ext = if e.empty? then nil else e end
    end

    module Utilities

      def self.destructure( hash )
        destructured = {}
        hash.keys.map { |key| key.split('.') }.each do |keys|
          destructure_with_array_keys(hash, '', keys, destructured)
        end
        destructured
      end

      private

      def self.destructure_with_array_keys( hash, prefix, keys, destructured )
        if keys.length == 1
          key = "#{prefix}#{keys.first}"
          val = hash[key]
          destructured[keys.first.intern] = case val
          when String
            val.strip
          when Hash, Array
            val
          when Array
            val
          when nil
            raise key.inspect
          end
        else
          destructured = ( destructured[keys.first.intern] ||= {} )
          new_prefix = "#{prefix}#{keys.shift}."
          destructure_with_array_keys( hash, new_prefix, keys, destructured )
        end
      end

    end

  end

end


