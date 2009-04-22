# require 'layers/rack/rack_cache'
module Blog

  module Configurations

    class Development < Default

      reloadable [ Blog ]

      # in case we want to use http caching
      # include Waves::Cache::RackCache
      application.use Rack::Session::Cookie,  :key => 'rack.session',
                                              :path => '/',
                                              :expire_after => 2592000,
                                              :secret => 'Change it'

      application.use ::Rack::Static, :urls => %w[ /css /javascript /favicon.ico ],
                                      :root => 'public'

      application.run Waves::Dispatchers::Default.new

      server  Waves::Servers::Mongrel
      host    "0.0.0.0"
      port    8080

    end

  end

end
