module Waves

  # Defines a set of methods that simplify accessing common request and response methods.
  # These include methods not necessarily associated with the Waves::Request and Waves::Response
  # objects, but which may still be useful for constructing a response.
  # This mixin assumes that a @request@ accessor already exists.
  
  module ResponseMixin  
    
    # Access the response.
    def response; request.response; end
    
    def resource; traits.waves.resource || ( self if self.kind_of? Waves::Resources::Mixin ) ; end

    def traits ; request.traits ; end
    
    # Access to the query string as a object where the keys are accessors
    # You can still access the original query as request.query
    def query ; @query ||= Waves::Request::Query.new( request.query ) ; end    
    
    # Elements captured the path
    def captured ; @captured ||= traits.waves.captured ; end
    
    # Both the query and capture merged together
    def params 
      @params ||= Waves::Request::Query.new( captured ? 
        request.query.merge( captured.to_h ) : request.query ) 
    end
    
    %w( session path url domain ).each do | m |
      define_method( m ) { request.send( m ) }
    end
    
    def log; Waves::Logger; end

    def app ; self.class.root ; end

    def main ; Waves.main ; end

    def paths( rname = nil )
      ( rname ? app::Resources[ rname ].paths : resource.class.paths ).new
    end

    def http_cache( last_modified )
      response.last_modified = last_modified
      modified?( last_modified ) ? yield : not_modified
    end

    def modified?( last_modified )
      request.if_modified_since.nil? || 
        last_modified > request.if_modified_since
    end
    
    # Raise a not found exception.
    def not_found
      raise Waves::Response::ClientErrors::NotFound.new
    end

    # Issue a redirect for the given path.
    def redirect( path )
      raise Waves::Response::Redirects::Found.new( path )
    end

    def not_modified
      raise Waves::Response::Redirects::NotModified.new
    end
    
  end

end
