module Waves

  # Waves::Response represents an HTTP response and has methods for constructing a response.
  # These include setters for +content_type+, +content_length+, +location+, and +expires+
  # headers. You may also set the headers directly using the [] operator. 
  # See Rack::Response for documentation of any method not defined here.

  class Response

    attr_reader :request

    # Create a new response. Takes the request object. You shouldn't need to call this directly.
    def initialize( request )
      @request = request
      @response = Rack::Response.new
    end

    def rack_response; @response; end

    %w( Content-Type Content-Length Location Expires ).each do |header|
      name = header.downcase.tr("-", "_")

      define_method("#{name}=") {|val| @response[header] = val }
      define_method("#{name}") {|val| @response[header] }
    end

    # Returns the sessions associated with the request, allowing you to set values within it.
    # The session will be created if necessary and saved when the response is complete.
    def session ; request.session ; end

    # Finish the response. This will send the response back to the client, so you shouldn't
    # attempt to further modify the response once this method is called. You don't usually
    # need to call it yourself, since it is called by the dispatcher once request processing
    # is finished.
    def finish ;  @response.finish ; end

    # Methods not explicitly defined by Waves::Response are delegated to Rack::Response.
    # Check the Rack documentation for more information
    extend Forwardable
    def method_missing( name, *args )
      if @response.respond_to?( name )
        # avoid having to use method missing in the future
        self.class.class_eval { def_delegator :@response, name }
        @response.send( name, *args )
      else
        super
      end
    end

  end
end
