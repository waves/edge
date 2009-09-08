module Waves

  class Server < Hive::Worker

    include Waves::Runtime
    
    def initialize( options = {} )
      require 'ruby-debug' if options[:debugger]
      super( options )
      load # load the runtime
    end
    
    def start_tasks
      @server = config.server.new( application, host, port )
      @server.start
    end

    def stop_tasks() ; @server.stop ; end

    private

    def application() ; @app ||= config.application.to_app ; end
    def port() ; ( @port ||= options[:port] || config.port ) ; end
    def host() ; ( @host ||= options[:host] || config.host ) ; end

  end

end
