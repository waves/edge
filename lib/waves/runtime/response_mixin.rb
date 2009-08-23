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
    
    %w( session path url domain not_found ).each do | m |
      define_method( m ) { request.send( m ) }
    end
    
    def redirect(location, status = '302'); request.redirect(location, status); end

    def log; Waves::Logger; end

    def app ; self.class.root ; end

    def main ; Waves.main ; end

    def paths( rname = nil )
      ( rname ? app::Resources[ rname ].paths : resource.class.paths ).new
    end

  end

end
