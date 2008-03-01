module Waves

	module Dispatchers

	  class NotFoundError < Exception ; end
		
		class Redirect < Exception 
			attr_reader :path
			def initialize( path )
				@path = path
			end
		end
		
		# The Base dispatcher simply makes it easier to write dispatchers by inheriting
		# from it. It creates a Waves request, ensures the request processing is done
		# within a mutex, benchmarks the request processing, logs it, and handles common 
		# exceptions and redirects. Derived classes need only process the request within 
		# their +safe+ method, which takes a Waves::Request and returns a Waves::Response.
		
		class Base
				
			# Like any Rack application, Waves' dispatchers must provide a call method
			# taking an +env+ parameter. 
			def call( env )
			  Waves::Server.synchronize do
  				request = Waves::Request.new( env )
  				response = request.response
  			  t = Benchmark.realtime do 
    				begin
    					safe( request )
    				rescue Dispatchers::Redirect => redirect
    					response.status = '302'
    					response.location = redirect.path
    				rescue Dispatchers::NotFoundError => e
    					html = Waves.application.views[:errors].process( request ) do
    				    not_found_404( :error => e ) 
    				  end
    					response.status = '404'
    					response.content_type = 'text/html'
    					response.write( html )
    				end
    			end
      		Waves::Logger.info "#{request.method}: #{request.url} handled in #{(t*1000).round} ms."
  				response.finish
  			end
  		end

		end

	end	
	
end