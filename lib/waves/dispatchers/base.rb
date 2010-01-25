module Waves

  module Dispatchers

    #
    # Waves::Dispatchers::Base provides the basic request processing structure
    # for a Rack application. It creates a Waves request, determines whether
    # to enclose the request processing in a mutex benchmarks it, logs it,
    # and handles redirects. Derived classes need only process the request
    # within the +safe+ method, which must take a Waves::Request and return
    # a Waves::Response.
    #

    class Base

      # As with any Rack application, a Waves dispatcher must provide a call method
      # that takes an +env+ hash.
      def call( env )
        response = if Waves.synchronize? || Waves.debug?
          Waves.synchronize { Waves.reload ; _call( env )  }
        else
          _call( env )
        end
      end

      # Called by event driven servers like thin and ebb. Returns true if
      # the server should run the request in a separate thread.
      def deferred?( env ) ; Waves.config.resource.new( Waves::Request.new( env ) ).deferred? ; end

      private

      def _call( env )
        request = Waves::Request.new( env )
        response = request.response
        t = Benchmark.realtime do
          begin
            response.write( safe( request ).to_s ) if response.body.empty?
          rescue Waves::Response::Packaged => e
            e.call( response ) if e.respond_to?( :call )
          else
            # safeish default
            response.content_type ||=  Waves::MimeTypes[ request.ext ].first || 'text/html'
            response.status ||= 200
          end
        end
        Waves::Logger.info "#{response.status}: #{request.method} #{request.url} handled in #{(t*1000).round} ms."
        response.finish
      end

    end

  end

end
