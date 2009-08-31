module Waves

  # Runtime to use with Rackup specifically.
  #
  # The actual Rack application is built using `config.application`
  # (see runtime/configuration.rb), not in the .ru file. Rackup
  # expects to be used in the context of an already-running server.
  # See the documentation for your webserver and Rack for details.
  #
  # Your config.ru file should minimally look something like this:
  #
  #   require "waves"
  #   require "waves/runtime/rackup"
  #
  #   run Waves::Rackup.load
  #
  class Rackup
    
    attr_accessor :options
    
    include Waves::Runtime

    # Load the runtime and return an application.
    def self.load(options = {})
      new( options )
      config.application.to_app
    end
    
    def initialize( options = {} )
      @options = options
      load # load runtime
    end

  end

end

